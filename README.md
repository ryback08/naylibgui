# naylibgui

Hello, here is my work to wrapping Raygui for [Naylib](https://github.com/planetis-m/naylib)

## Installation

To install this wrapper, run :  
`nimble install https://github.com/ryback08/naylibgui`

## How to use.
Import naylibgui in your file.
naylibgui export also naylib.
See [example file](/exemples/examples/controls_test_suite/controlTestSuite.nim)


## Examples
i reproduce controlTestSuite.c in controlTestSuite.nim  
The majority of functions work ..... but not all yet.

![control test suite - Defaut style](/exemples/examples/controls_test_suite/controls%20test%20suite%20-%20defaut%20style.png)

![control test suite- Dark Style](/exemples/examples/controls_test_suite/controls%20test%20suite%20-%20dark%20style.png)

## Problematic and to do list.
- You must manualy allocate enough space for function point on cstring ( ex: guiTextBox )
- I did not succed to wrapp pointer on pointer (guiListViewEx). Try to use allocCStringArray... but not working.
- Check if guiSetStyle works correctly (strange behavior : the function seems to be apply globaly and not locally)

