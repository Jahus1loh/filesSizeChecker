# 📁 File Type Statistics Script

A Bash script to analyze files in a given directory (or current directory by default) and generate statistics for different file types including documents, graphics, music, videos, and others.

## 📌 Features

* Calculates **average**, **maximum**, **minimum**, and **median** sizes of files grouped by type.
* Supports recursive scanning of subdirectories.
* Human-readable output format using `numfmt`.
* Optional CLI flags to limit output to specific file types.
* Built-in help and version info.

## 📂 Supported File Categories

| Category | File Type Keywords Detected                                     |
| -------- | --------------------------------------------------------------- |
| Document | ASCII, CSV, data, OpenDocument, PHP, JSON, C++, HTML, Java, pdf |
| Graphic  | JPEG, PNG, GIF                                                  |
| Music    | Audio                                                           |
| Video    | ISO                                                             |
| Other    | All other file types not matching above                         |

## 🚀 Usage

```bash
./file_stats.sh [options]
```

If no options are provided, it prints statistics for **all file types**.

### Available Options

| Option | Description                         |
| ------ | ----------------------------------- |
| `-h`   | Show help information               |
| `-v`   | Show version and author information |
| `-d`   | Show statistics for document files  |
| `-g`   | Show statistics for graphic files   |
| `-m`   | Show statistics for music files     |
| `-p`   | Show statistics for video files     |
| `-o`   | Show statistics for other files     |

## 💡 Example

```bash
$ ./file_stats.sh -d -g
Provide a directory path: 
Average size of document files:     12.35MiB
Maximum size of document files:     24.00MiB
Minimum size of document files:      2.00MiB
Median size of document files:      11.00MiB

Average size of graphic files:       8.13MiB
Maximum size of graphic files:      15.00MiB
Minimum size of graphic files:       1.00MiB
Median size of graphic files:        7.00MiB
```

## 🧔 Author

* **Jan Pastucha**
* Version: **1.0.2**
