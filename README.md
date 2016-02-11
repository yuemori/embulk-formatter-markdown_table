# Markdown Table formatter plugin for Embulk

This plugin is Markdown Table formatter for Embulk.

## Overview

* **Plugin type**: formatter

## Configuration

- **encoding**: output encoding. (string, default: `"UTF-8"`)
- **newline**: newline character. (string, default: `"LF"`)
  - CRLF: use \r(0x0d) and \n(0x0a) as newline character
  - LF: use \n(0x0a) as newline character
  - CR: use \r(0x0d) as newline character
  - NUL: use \0(0x00) instead of newline

## Example

### input

```
id,account,time,purchase,comment
1,32864,2015-01-27 19:23:49,20150127,embulk
2,14824,2015-01-27 19:01:23,20150127,embulk jruby
3,27559,2015-01-28 02:20:02,20150128,"Embulk ""csv"" parser plugin"
4,11270,2015-01-29 11:54:36,20150129,NULL
```

### config

```yaml
out:
  type: markdown_table
  formatter:
    type: markdown_table
    encoding: UTF-8 # optional
    newline: LF # optional
```

### output

```
|id|account|time|purchase|comment|
|---|---|---|---|---|
|1|32864|2015-01-27 19:23:49 UTC|2015-01-27 00:00:00 UTC|embulk|
|2|14824|2015-01-27 19:01:23 UTC|2015-01-27 00:00:00 UTC|embulk jruby|
|3|27559|2015-01-28 02:20:02 UTC|2015-01-28 00:00:00 UTC|Embulk "csv" parser plugin|
|4|11270|2015-01-29 11:54:36 UTC|2015-01-29 00:00:00 UTC|NULL|
```


## Build

```
$ rake
```
