## PHP

TODO

### Eval

Some web applications allow web requests to include data which gets sent to `eval()`, generally to allow the front-end to execute back-end commands. Doing this is very bad for security as it allows clients to execute potentially arbitrary code. This sort of problem can often be found with the following command: 

```sh
#!/bin/sh
grep -r "eval(" /var/www # replace /var/www with the web root
```
