A simple Ruby script to dictate files.

I often create small audio scripts that I want the computer to read aloud ...  But it's a hassle to write code, so this thing takes a file as an argument and then reads it aloud using the built in Mac voices.

See the sample.txt for an example.

Usage:

```
ruby main.rb sample.txt
```

If you're working on a script and don't actually want it to "execute", run it with a `TEST` environment variable:

```
TEST=yes ruby main.rb sample.txt
```
