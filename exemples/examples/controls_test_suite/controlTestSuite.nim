#[
/*******************************************************************************************
*
*   raygui - controls test suite
*
*   TEST CONTROLS:
*       - GuiDropdownBox()
*       - GuiCheckBox()
*       - GuiSpinner()
*       - GuiValueBox()
*       - GuiTextBox()
*       - GuiButton()
*       - GuiComboBox()
*       - GuiListView()
*       - GuiToggleGroup()
*       - GuiColorPicker()
*       - GuiSlider()
*       - GuiSliderBar()
*       - GuiProgressBar()
*       - GuiColorBarAlpha()
*       - GuiScrollPanel()
*
*
*   DEPENDENCIES:
*       raylib 4.5          - Windowing/input management and drawing
*       raygui 3.5          - Immediate-mode GUI controls with custom styling and icons
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -I../../src -lraylib -lopengl32 -lgdi32 -std=c99
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2016-2023 Ramon Santamaria (@raysan5)
*
**********************************************************************************************/
]#


import naylibgui

# raygui embedded styles
# For windows, you need modify header file. juste replace all Rectangle by rlRectangle
import std/os
when defined(windows):
  const dark = currentSourcePath().parentDir()/"../../styles/dark/style_dark_win.h"
else
  const dark = currentSourcePath().parentDir()/"../../styles/dark/style_dark.h"

# warping 
proc guiLoadStyleDark() {.cdecl, importc: "GuiLoadStyleDark", header: dark}




#//------------------------------------------------------------------------------------
#// Program main entry point
#//------------------------------------------------------------------------------------

proc main =
  #initialisation
  const
    screenWidth = 690
    screenHeight = 560

  initWindow(screenWidth, screenHeight, "raygui - controls test suite")
  setExitKey(Zero)

  #// GUI controls initialization
  #//----------------------------------------------------------------------------------
  var
    dropdownBox000Active: int32 = 0
    dropDown000EditMode: bool = false

    dropdownBox001Active: int32 = 0
    dropDown001EditMode: bool = false

    spinner001Value: int32 = 0
    spinnerEditMode: bool = false

    valueBox002Value: int32 = 0
    valueBoxEditMode: bool = false

  # TextBox : need allocate memory
  var textBoxText = create(cstring, 64)
  copyMem(textBoxText, "Text box".cstring, 8)
  
  var
    textBoxEditMode:bool = false

    textBoxMultiText: cstring = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\n\nThisisastringlongerthanexpectedwithoutspacestotestcharbreaksforthosecases,checkingifworkingasexpected.\n\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    textBoxMultiEditMode: bool = false

    listViewScrollIndex: int32 = 0
    listViewActive: int32 = -1
  
  var
    listViewExScrollIndex: int32 = 0
    listViewExActive: int32 = 2
    listViewExFocus: int32 = -1
  # @ to do convert to cstringArray ?
  #var char *listViewExList[8] = { "This", "is", "a", "list view", "with", "disable", "elements", "amazing!" };
    listViewExListOA: seq[string] = @["This", "is", "a", "list view", "with", "disable", "elements", "amazing!"]
    listViewExList: cstringArray = allocCStringArray(listViewExListOA)

    back = cstringArrayToSeq(listViewExList)
  echo back

  #let listViewExListCstring : seq[cstring] = @["This", "is", "a", "list view", "with", "disable", "elements", "amazing!" ]
  #let listViewExList = ptr UncheckedArray(listViewExListCstring)
  #let listViewExList : array[8, cstring ] = ["This", "is", "a", "list view", "with", "disable", "elements", "amazing!"]

  # = ["This", "is", "a", "list view", "with", "disable", "elements", "amazing!" ]
  var
    #multiTextBoxText[256]: char = "Multi text box"
    multiTextBoxEditMode: bool = false
    colorPickerValue: Color = RED

    sliderValue: float32 = 50.0
    sliderBarValue: float32 = 60
    progressValue: float32 = 0.4

    forceSquaredChecked: bool = false

    alphaValue: float32 = 0.5f

    #comboBoxActive: int = 1
    visualStyleActive: int32 = 0
    prevVisualStyleActive: int32 = 0

    toggleGroupActive: int32 = 0
    toggleSliderActive: int32 = 0
    

    viewScroll: Vector2 = Vector2(x:0.0, y:0.0)

  #//----------------------------------------------------------------------------------

  #// Custom GUI font loading
  #var font: Font = loadFont("fonts/rainyhearts16.ttf", 12, 0, 0)
  #loadFont()
  #guiSetFont(font)

  var
    exitWindow: bool = false
    showMessageBox: bool = false


    textInput = create(cstring, 256)
    textInputFileName = create(cstring, 256)
    #textInput: cstring = cast[cstring](alloc0(256*sizeof(cstring)))#"" #textInput[256]: char = { 0 }
    #textInputFileName: cstring = cast[cstring](alloc0(256*sizeof(cstring))) ##char textInputFileName[256] = { 0 };
    #textInputRawAlloc = alloc0(256)
    #textInput = cast[ptr UncheckedArray[char]](textInputRawAlloc)
    showTextInputBox: bool = false

    alpha: float = 1.0

  #DEBUG: Testing how those two properties affect all controls!
  #GuiSetStyle(DEFAULT, TEXT_PADDING, 0);
  #GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

  setTargetFPS(60) # Set our game to run at 60 frames-per-second
  #//--------------------------------------------------------------------------------------

  #// Main game loop
  while not windowShouldClose(): # Detect window close button or ESC key
    #clearBackground(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))

    exitWindow = windowShouldClose()

    if isKeyPressed(Escape): showMessageBox = not showMessageBox

    if isKeyPressed(LeftControl) and isKeyPressed(S):
      showTextInputBox = true

      # IsFileDropped..  @ to do

    #alpha -= 0.002f
    if (alpha < 0.0): alpha = 0.0
    if isKeyPressed(Space): alpha = 1.0
    
    guiSetAlpha(alpha)

    #progressValue += 0.002f
    if (isKeyPressed(Left)): progressValue -= 0.1f
    else:
      if (isKeyPressed(Right)): progressValue += 0.1f
    if (progressValue > 1.0f): progressValue = 1.0f
    else:
      if (progressValue < 0.0f): progressValue = 0.0f

    if (visualStyleActive != prevVisualStyleActive):
      guiLoadStyleDefault()
      
      case visualStyleActive:
        of 0 : discard
        of 1 : discard  #GuiLoadStyleJungle(); break;
        of 2 : discard  #GuiLoadStyleLavanda(); break;
        of 3 : guiLoadStyleDark()  #GuiLoadStyleDark(); break;
        of 4 : discard  #GuiLoadStyleBluish(); break;
        of 5 : discard  #GuiLoadStyleCyber(); break;
        of 6 : discard  #GuiLoadStyleTerminal(); break;
        else : discard

      guiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
      prevVisualStyleActive = visualStyleActive
    #//----------------------------------------------------------------------------------

    #// Draw
    #//----------------------------------------------------------------------------------

    beginDrawing()
    
    #clearBackground(RayWhite)
    clearBackground(getColor(guiGetStyle(DEFAULT, BACKGROUND_COLOR).uint32))
    
    # raygui: controls drawing
    #----------------------------------------------------------------------------------
    # Check all possible events that require GuiLock
    if (dropDown000EditMode or dropDown001EditMode): guiLock()


    ####################### First GUI column #######################
    #guiSetStyle(CHECKBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    #guiCheckBox(Rectangle(x:25.0, y:108.0, width:15.0, height:15.0 ), "FORCE CHECK!", forceSquaredChecked)
    guiCheckBox(rectangle(25.0, 108.0, 15.0, 15 ), "FORCE CHECK!", forceSquaredChecked)
    guiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    #guiSetStyle(VALUEBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)

    if (guiSpinner(Rectangle(x:25.0, y:135.0, width:125.0, height:30.0), "", spinner001Value, 0, 100, spinnerEditMode) > 0):
     spinnerEditMode = not spinnerEditMode
    
    if (guiValueBox(Rectangle(x:25.0, y:175.0, width:125.0, height: 30.0 ), "", valueBox002Value, 0, 100, valueBoxEditMode) > 0):
     valueBoxEditMode = not valueBoxEditMode
    

    guiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    ##############################################################################################
    ## guiTextBox : WARING error SIGSEGV: Illegal storage access. (Attempt to read from nil?) when edit text
    if (guiTextBox(rectangle(25, 215, 125, 30), textBoxText , 64, textBoxEditMode) > 0) : textBoxEditMode = not textBoxEditMode
    ###############################################################################################
    
    
    guiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    
    if (guiButton(rectangle(25, 255, 125, 30), guiIconText(ICON_FILE_SAVE, "Save File"))): showTextInputBox = true
    
    guiGroupBox(rectangle(25, 310, 125, 150), "STATES")
    guiLock();
    guiSetState(STATE_NORMAL)
    if guiButton(rectangle( 30, 320, 115, 30), "NORMAL"): discard
    guiSetState(STATE_FOCUSED)
    if guiButton(rectangle(30, 355, 115, 30), "FOCUSED"): discard
    guiSetState(STATE_PRESSED)
    if guiButton(rectangle(30, 390, 115, 30), "#15#PRESSED"): discard
    guiSetState(STATE_DISABLED)
    if guiButton(rectangle(30, 425, 115, 30), "DISABLED"): discard
    guiSetState(STATE_NORMAL)
    guiUnlock()
    
    guiComboBox(Rectangle(x:25.0, y:480.0, width:125.0, height:30.0 ), "default;Jungle;Lavanda;Dark;Bluish;Cyber;Terminal", visualStyleActive)

    # // NOTE: GuiDropdownBox must draw after any other control that can be covered on unfolding
    guiUnlock()
    guiSetStyle(DROPDOWNBOX, TEXT_PADDING, 4)
    guiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    if (guiDropdownBox(rectangle(25, 65, 125, 30), "#01#ONE;#02#TWO;#03#THREE;#04#FOUR", dropdownBox001Active, dropDown001EditMode)>0):
      dropDown001EditMode = not dropDown001EditMode
    guiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    guiSetStyle(DROPDOWNBOX, TEXT_PADDING, 0)

    if (guiDropdownBox(rectangle(25, 25, 125, 30), "ONE;TWO;THREE", dropdownBox000Active, dropDown000EditMode)>0) :
      dropDown000EditMode = not dropDown000EditMode

    ####################### Second GUI column #######################
    guiListView(Rectangle(x:165.0, y:25.0, width:140.0, height:124.0), "Charmander;Bulbasaur;#18#Squirtel;Pikachu;Eevee;Pidgey", listViewScrollIndex, listViewActive)
    ##############################################################################################
    # undefined reference to `guiListViewEx'
    #guiListViewEx(rectangle(165.0, 162.0, 140.0, 184.0), listViewExList, 8, listViewExScrollIndex, listViewExActive,listViewExFocus)
    ##############################################################################################


    # guiToggle(rectangle(165, 400, 140, 25), "#1#ONE", toggleGroupActive)
    guiToggleGroup(rectangle(165, 360, 140, 24), "#1#ONE\n#3#TWO\n#8#THREE\n#23#", toggleGroupActive)
    # guiDisable()
    guiSetStyle(SLIDER, SLIDER_PADDING, 2)
    guiToggleSlider(rectangle(165, 480, 140, 30), "ON;OFF", toggleSliderActive)
    guiSetStyle(SLIDER, SLIDER_PADDING, 0)

    ####################### Third GUI column #######################
    guiPanel(rectangle(320, 25, 225, 140), "Panel Info")
    guiColorPicker(rectangle(320, 185, 196, 192), "", colorPickerValue)

    # guiDisable()
    guiSlider(rectangle(355, 400, 165, 20), "TEST".cstring, ($sliderValue).cstring, sliderValue, -50'f32, 100'f32)
    guiSliderBar(rectangle(320, 430, 200, 20), nil, ($sliderBarValue).cstring, sliderBarValue, 0, 100)
    
    guiProgressBar(rectangle(320, 460, 200, 20), nil, ($(progressValue*100)).cstring, progressValue, 0.0'f32, 1.0'f32)
    guiEnable()

    # // NOTE: View rectangle could be used to perform some scissor test
    var view: Rectangle = rectangle(0,0,0,0)
    guiScrollPanel(rectangle(560, 25, 102, 354), nil, rectangle(560, 25, 300, 1200), viewScroll.addr, view.addr)

    var mouseCell:Vector2
    guiGrid(rectangle(560, 25 + 180 + 195, 100, 120), "", 20, 3, mouseCell)

    guiColorBarAlpha(rectangle(320, 490, 200, 30), "", alphaValue)

    guiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_TOP)   # WARNING: Word-wrap does not work as expected in case of no-top alignment
    guiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD)           # WARNING: If wrap mode enabled, text editing is not supported
    if (guiTextBox(rectangle(678, 25, 258, 492), textBoxMultiText.addr, 1024, textBoxMultiEditMode)) > 0 :
      textBoxMultiEditMode = not textBoxMultiEditMode
    guiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_NONE)
    guiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE)

    guiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    guiStatusBar(rectangle(0, getScreenHeight() - 20 ,getScreenWidth(), 20 ), "This is a status bar")
    guiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    #guiSetStyle(STATUSBAR, TEXT_INDENTATION, 20)

    if (showMessageBox):
      drawRectangle(0, 0, getScreenWidth(), getScreenHeight(), fade(RAYWHITE, 0.8f))
      var result: int32 = guiMessageBox(rectangle(getScreenWidth()/2 - 125, getScreenHeight()/2 - 50, 250, 100 ), guiIconText(ICON_EXIT, "Close Window"), "Do you really want to exit?", "Yes;No")

      if ((result == 0) or (result == 2)) :
        showMessageBox = false
      elif (result == 1) :
        exitWindow = true
    # }

    if (showTextInputBox):
      drawRectangle(0, 0, getScreenWidth(), getScreenHeight(), fade(RAYWHITE, 0.8f))
      var result = guiTextInputBox(rectangle(getScreenWidth()/2 - 120, getScreenHeight()/2 - 60, 240, 140), guiIconText(ICON_FILE_SAVE, "Save file as..."), "Introduce output file name:" , "Ok;Cancel" , textInput , 255, nil)
      

      if (result == 1):
        #         // TODO: Validate textInput value and save
        copyMem(textInputFileName,textInput, 256)
        echo result
    
      if ((result == 0) or (result == 1) or (result == 2)):
        showTextInputBox = false
        copyMem(textInputFileName,"\0".cstring, 1)  #textInput = "\0"
        
        echo result

    # //----------------------------------------------------------------------------------








    endDrawing()
    # ------------------------------------------------------------------------------------
  # De-Initialization
  # --------------------------------------------------------------------------------------
  closeWindow() # Close window and OpenGL context
  # --------------------------------------------------------------------------------------

main()


  
