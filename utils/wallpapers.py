#!/usr/bin/env python3
"""Discover wallpapers and persist the selected path without shell interpolation."""
import hashlib
import json
import subprocess
import os
import sys
import tempfile
import time


def scan(directory, state_file, cache):
    cleanup(cache)
    images = []
    for root, dirs, files in os.walk(directory, followlinks=False):
        dirs[:] = [name for name in dirs if not name.startswith('.') and not os.path.islink(os.path.join(root, name))]
        for name in files:
            if not name.startswith('.') and os.path.splitext(name)[1].lower() in ('.jpg', '.jpeg', '.png', '.webp'):
                images.append(os.path.join(root, name))
    images.sort(key=lambda path: (os.path.basename(path).casefold(), path.casefold(), path))
    try:
        with open(state_file, encoding='utf-8') as state:
            selected = json.load(state).get('wallpaper', '')
            if not isinstance(selected, str):
                selected = ''
    except (OSError, ValueError, AttributeError):
        selected = ''
    print(json.dumps({'images': images, 'selected': selected}, ensure_ascii=True))


def save(state_file, path):
    directory = os.path.dirname(state_file)
    os.makedirs(directory, exist_ok=True)
    temp = None
    try:
        with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', dir=directory, delete=False) as out:
            temp = out.name
            json.dump({'wallpaper': path}, out, ensure_ascii=True)
        os.replace(temp, state_file)
    finally:
        if temp and os.path.exists(temp):
            os.unlink(temp)


def dimensions(path):
    result = subprocess.run(['magick', 'identify', '-ping', '-format', '%w %h %[orientation]', path + '[0]'], check=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
    parts = result.stdout.strip().split()
    width, height = int(parts[0]), int(parts[1])
    if len(parts) > 2 and parts[2] in ('LeftTop', 'RightTop', 'RightBottom', 'LeftBottom'):
        width, height = height, width
    print(json.dumps([width, height]))


def cleanup(cache):
    try:
        entries = os.scandir(cache)
    except OSError:
        return
    cutoff = time.time() - 30 * 24 * 60 * 60
    with entries:
        for entry in entries:
            try:
                stem, ext = os.path.splitext(entry.name)
                if ext == '.jpg' and len(stem) == 64 and all(c in '0123456789abcdef' for c in stem) and entry.is_file(follow_symlinks=False) and entry.stat(follow_symlinks=False).st_mtime < cutoff:
                    os.unlink(entry.path)
            except OSError:
                pass


def thumbnail(cache, path):
    stat = os.stat(path)
    key = hashlib.sha256(os.fsencode(path) + str((stat.st_mtime_ns, stat.st_size)).encode()).hexdigest()
    os.makedirs(cache, exist_ok=True)
    dest = os.path.join(cache, key + '.jpg')
    if not os.path.exists(dest):
        fd, temp = tempfile.mkstemp(suffix='.jpg', dir=cache)
        os.close(fd)
        try:
            subprocess.run(['magick', path + '[0]', '-thumbnail', '480x270^', '-gravity', 'center', '-extent', '480x270', '-quality', '85', temp], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            os.replace(temp, dest)
        finally:
            if os.path.exists(temp):
                os.unlink(temp)
    try:
        os.utime(dest, None)
    except OSError:
        pass
    print(json.dumps(dest))


if __name__ == '__main__':
    if sys.argv[1] == 'scan':
        scan(sys.argv[2], sys.argv[3], sys.argv[4])
    elif sys.argv[1] == 'dimensions':
        dimensions(sys.argv[2])
    elif sys.argv[1] == 'thumbnail':
        thumbnail(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == 'save':
        save(sys.argv[2], sys.argv[3])
