# picelo

`picelo` is a quick and easy to use bash script that processes text files that have references to images hosted on external servers.

It fetches the images, optimizes and stores them in a customisable local folder structure to keep the assets organized. Additionally, if it encounters local image files, they are copied over after being processed through [`cwebp`](https://developers.google.com/speed/webp/docs/cwebp) optimization.

This is useful in case you want to gather your assets hosted on external services for preparing migration to a self hosted solution.

The local image file formats processed for optimization are JPG, PNG and GIF. The text file formats tested and supported are HTML, Markdown and MDX. But literally any text file with references to image URLs should work.

## Installation

The script installation is simple. Just download the version specific bash file and create an executable alias for its install location. Here are the commands you need to run to setup `picelo`:

```shell
curl -fsSL https://raw.githubusercontent.com/gouravkhunger/picelo/0.1.0/picelo.sh -o ~/bin/picelo.sh
chmod +x ~/bin/picelo.sh
echo "alias picelo=\"~/bin/picelo.sh\"" >> ~/.zshrc
source ~/.zshrc
```

## Usage

`picelo` works by recursively looping through the files and folders under the directory it is invoked in. Consider the tree for a folder:

```shell
example
├── content
│   ├── abc # sub-directories
│   │   └── def
│   │       └── how-to-make-accordions-in-android.md
│   ├── how-to-make-accordions-in-android.md # article with images
│   └── img
│       └── 3bqWDusIb.png # Plain image
├── overview.mdx
└── dist
    └── index.html
```

Running `picelo` inside the `example` folder would loop through the files, download images from URLs and optimizes them using `cwebp`.

Please note that the optimized images are stored in a structure similar to how they exist. So an image `https://example.com/img.png` inside `example/article.md` would end up in `<folder>/example/article/img.png`.

All images are converted to the `webp` format. Here's the folder structure that would be generated for the example above:

```shell
example
├── assets
│   └── images
│       ├── content
│       │   ├── abc
│       │   │   └── def
│       │   │       └── how-to-make-accordions-in-android
│       │   │           ├── OP9Cg1kSL.webp
│       │   │           └── Wlmpz56ye.webp
│       │   ├── how-to-make-accordions-in-android
│       │   │   ├── OP9Cg1kSL.webp
│       │   │   └── Wlmpz56ye.webp
│       │   └── img
│       │       └── 3bqWDusIb.webp
│       ├── overview
│       │   └── tree-736885_1280.webp
│       └── dist
│           └── index
│               ├── image.webp
│               └── tree-736885_1280.webp
├── content
│   └── ...
├── overview.mdx
└── dist
    └── ...
```

As of now `<folder>` refers to `./assets/images`. All images inside `article.md` would end up in the corresponding `article` folder.

## Options

### Excluding folders (`-e`)

If you wish to exclude files in certain folders from being processed by `picelo`, please use the `-e` flag to pass the names of folders to be excluded:

```shell
picelo -e "media|example"
# Excludes folders 'media' and 'example'
```

## License

The software is available as open source under the terms of the [MIT License](https://github.com/gouravkhunger/picelo/blob/main/LICENSE).

```
MIT License

Copyright (c) 2024 Gourav Khunger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
