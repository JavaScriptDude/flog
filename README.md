# flog
Follow Logs in Linux and wait for log to exist if not found

```
Usage: flog [options] <file_name>
Simple wrapper for tail command with defaults --follow=name --retry --lines 250 --verbose)
Options:
  -q, --quiet     dont output headers giving file names
  -n, --lines <n> output the last <n> lines (default: 250)
  -h, --help      show this help message
  <any other tail(h) option>
```
