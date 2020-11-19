# Commands from ZCLI1.pdf

```
zowe files create ps Z05336.ZOWEPS --rl 120 --block-size 9600
zowe files list ds Z05336.ZOWEPS -a

zowe  zos-files create data-set-vsam Z05336.VSAMDS -v VPWRKC
zowe files list ds Z05336.VSAMDS -a

zowe jobs submit lf "repro.txt"
zowe jobs submit lf "repro-print.txt"


zowe files create ps Z05336.OUTPUT.VSAMPRNT --rl 120 --block-size 9600
```
