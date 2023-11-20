######################################################################################################
## raygui for nim.
## manual Warrping
## based on raygui.h v4.0 : https://github.com/raysan5/raygui/blob/master/src/raygui.h
##
## 
##
## proof of work
## simple warrping.
## 
## 
## *   CONTROLS PROVIDED:
# *     # Container/separators Controls
# *       - WindowBox     --> StatusBar, Panel
# *     V  - GroupBox      --> Line
# *       - Line
# *     V  - Panel         --> StatusBar
# *       - ScrollPanel   --> StatusBar
# *       - TabBar        --> Button
# *
# *     # Basic Controls
# *       - Label
# *       - LabelButton   --> Label
# *     V  - Button                                    
# *       - Toggle
# *       - ToggleGroup   --> Toggle
# *       - ToggleSlider
# *     V  - CheckBox
# *     V  - ComboBox
# *     V  - DropdownBox
# *     X  - TextBox                                     # does not work correctly
# *     V  - ValueBox      --> TextBox
# *     V  - Spinner       --> Button, ValueBox
# *     V  - Slider
# *       - SliderBar     --> Slider
# *       - ProgressBar
# *       - StatusBar
# *       - DummyRec
# *       - Grid
# *
# *     # Advance Controls
# *     V  - ListView
# *     X  - ListViewEx
# *     V - ColorPicker   --> ColorPanel, ColorBarHue
# *       - MessageBox    --> Window, Label, Button
# *       - TextInputBox  --> Window, Label, TextBox, Button
## 
## 
## 
## 
##
######################################################################################################




import raylib
export raylib

import std/os

when defined(windows):
  const rayguiHeader = currentSourcePath().parentDir()/"rayguiwin.h"    # raygui.h modified for windows. Just replace all Rectangle by rlRectangle
else:
  const rayguiHeader = currentSourcePath().parentDir()/"raygui.h"
{.passC: "-DRAYGUI_IMPLEMENTATION".}




#Style property
#
type
  GuiStyleProp* {.importc: "GuiStyleProp", header: rayguiHeader, bycopy.} = object
    controlId* {.importc: "controlId".}: cushort
    propertyId* {.importc: "propertyId".}: cushort
    propertyValue* {.importc: "propertyValue".}: cint


##  Gui control state
type
  GuiState* {.size: sizeof(int32).} = enum
    STATE_NORMAL = 0, STATE_FOCUSED, STATE_PRESSED, STATE_DISABLED

##  Gui control text alignment
type
  GuiTextAlignment* {.size: sizeof(int32).} = enum
    TEXT_ALIGN_LEFT = 0,
    TEXT_ALIGN_CENTER,
    TEXT_ALIGN_RIGHT

# Gui control text alignment vertical
# NOTE: Text vertical position inside the text bounds
type
  GuiTextAlignmentVertical* {.size: sizeof(int32).} = enum
    TEXT_ALIGN_TOP = 0,
    TEXT_ALIGN_MIDDLE,
    TEXT_ALIGN_BOTTOM


# Gui control text wrap mode
# NOTE: Useful for multiline text
type
  GuiTextWrapMode* {.size: sizeof(int32).} = enum
    TEXT_WRAP_NONE = 0,
    TEXT_WRAP_CHAR,
    TEXT_WRAP_WORD

##  Gui controls
type
  GuiControl* {.size: sizeof(int32).} = enum
    #Default -> populates to all controls when set
    DEFAULT = 0,
    # Basic controls
    LABEL,          # Used also for: LABELBUTTON
    BUTTON,
    TOGGLE,         # Used also for: TOGGLEGROUP
    SLIDER,         # Used also for: SLIDERBAR, TOGGLESLIDER
    PROGRESSBAR,
    CHECKBOX,
    COMBOBOX,
    DROPDOWNBOX,
    TEXTBOX,        # Used also for: TEXTBOXMULTI
    VALUEBOX,
    SPINNER,        # Uses: BUTTON, VALUEBOX
    LISTVIEW,
    COLORPICKER,
    SCROLLBAR,
    STATUSBAR

## Gui base properties for every control
type
  GuiControlProperty* {.size: sizeof(int32).} = enum
    BORDER_COLOR_NORMAL = 0,    # Control border color in STATE_NORMAL
    BASE_COLOR_NORMAL,          # Control base color in STATE_NORMAL
    TEXT_COLOR_NORMAL,          # Control text color in STATE_NORMAL
    BORDER_COLOR_FOCUSED,       # Control border color in STATE_FOCUSED
    BASE_COLOR_FOCUSED,         # Control base color in STATE_FOCUSED
    TEXT_COLOR_FOCUSED,         # Control text color in STATE_FOCUSED
    BORDER_COLOR_PRESSED,       # Control border color in STATE_PRESSED
    BASE_COLOR_PRESSED,         # Control base color in STATE_PRESSED
    TEXT_COLOR_PRESSED,         # Control text color in STATE_PRESSED
    BORDER_COLOR_DISABLED,      # Control border color in STATE_DISABLED
    BASE_COLOR_DISABLED,        # Control base color in STATE_DISABLED
    TEXT_COLOR_DISABLED,        # Control text color in STATE_DISABLED
    BORDER_WIDTH,               # Control border size, 0 for no border
    #TEXT_SIZE,                  /#Control text size (glyphs max height) -> GLOBAL for all controls
    #TEXT_SPACING,               /#Control text spacing between glyphs -> GLOBAL for all controls
    #TEXT_LINE_SPACING           /#Control text spacing between lines -> GLOBAL for all controls
    TEXT_PADDING,               # Control text padding, not considering border
    TEXT_ALIGNMENT,             # Control text horizontal alignment inside control text bound (after border and padding)
    #TEXT_WRAP_MODE              /#Control text wrap-mode inside text bounds -> GLOBAL for all controls

## Gui extended properties depend on control
  GuiDefaultProperty* {.size: sizeof(int32).} = enum
    TEXT_SIZE = 16,             # Text size (glyphs max height)
    TEXT_SPACING,               # Text spacing between glyphs
    LINE_COLOR,                 # Line control color
    BACKGROUND_COLOR,           # Background color
    TEXT_LINE_SPACING,          # Text spacing between lines
    TEXT_ALIGNMENT_VERTICAL,    # Text vertical alignment inside text bounds (after border and padding)
    TEXT_WRAP_MODE              # Text wrap-mode inside text bounds
    #TEXT_DECORATION             # Text decoration: 0-None, 1-Underline, 2-Line-through, 3-Overline
    #TEXT_DECORATION_THICK       # Text decoration line thikness

type
  GuiToggleProperty* {.size: sizeof(int32).} = enum
    GROUP_PADDING = 16

##  Slider/SliderBar
type
  GuiSliderProperty* {.size: sizeof(int32).} = enum
    SLIDER_WIDTH = 16, SLIDER_PADDING

##  ProgressBar
type
  GuiProgressBarProperty* {.size: sizeof(int32).} = enum
    PROGRESS_PADDING = 16

# ScrollBar
type
  GuiScrollBarProperty* {.size: sizeof(int32).} = enum
    ARROWS_SIZE = 16,           # ScrollBar arrows size
    ARROWS_VISIBLE,             # ScrollBar arrows visible
    SCROLL_SLIDER_PADDING,      # ScrollBar slider internal padding
    SCROLL_SLIDER_SIZE,         # ScrollBar slider size
    SCROLL_PADDING,             # ScrollBar scroll padding from arrows
    SCROLL_SPEED,               # ScrollBar scrolling speed

##  CheckBox
type
  GuiCheckBoxProperty* {.size: sizeof(int32).} = enum
    CHECK_PADDING = 16

# ComboBox
type
  GuiComboBoxProperty* {.size: sizeof(int32).} = enum
    COMBO_BUTTON_WIDTH = 16,    # ComboBox right button width
    COMBO_BUTTON_SPACING        # ComboBox button separation

# DropdownBox
type
  GuiDropdownBoxProperty* {.size: sizeof(int32).} = enum
    ARROW_PADDING = 16,         # DropdownBox arrow separation from border and items
    DROPDOWN_ITEMS_SPACING      # DropdownBox items separation

# TextBox/TextBoxMulti/ValueBox/Spinner
type
  GuiTextBoxProperty* {.size: sizeof(int32).} = enum
    TEXT_READONLY = 16,         # TextBox in read-only mode: 0-text editable, 1-text no-editable

# Spinner
type
  GuiSpinnerProperty* {.size: sizeof(int32).} = enum
    SPIN_BUTTON_WIDTH = 16,     # Spinner left/right buttons width
    SPIN_BUTTON_SPACING,        # Spinner buttons separation

# ListView
type
  GuiListViewProperty* {.size: sizeof(int32).} = enum
    LIST_ITEMS_HEIGHT = 16,     # ListView items height
    LIST_ITEMS_SPACING,         # ListView items separation
    SCROLLBAR_WIDTH,            # ListView scrollbar size (usually width)
    SCROLLBAR_SIDE,             # ListView scrollbar side (0-SCROLLBAR_LEFT_SIDE, 1-SCROLLBAR_RIGHT_SIDE)

# ColorPicker
type
  GuiColorPickerProperty* {.size: sizeof(int32).} = enum
    COLOR_SELECTOR_SIZE = 16,
    HUEBAR_WIDTH,               # ColorPicker right hue bar width
    HUEBAR_PADDING,             # ColorPicker right hue bar separation from panel
    HUEBAR_SELECTOR_HEIGHT,     # ColorPicker right hue bar selector height
    HUEBAR_SELECTOR_OVERFLOW    # ColorPicker right hue bar selector overflow



#//----------------------------------------------------------------------------------
#// Icons enumeration
#//----------------------------------------------------------------------------------
type
  GuiIconName*{.size: sizeof(int32).} = enum
    ICON_NONE                     = 0,
    ICON_FOLDER_FILE_OPEN         = 1,
    ICON_FILE_SAVE_CLASSIC        = 2,
    ICON_FOLDER_OPEN              = 3,
    ICON_FOLDER_SAVE              = 4,
    ICON_FILE_OPEN                = 5,
    ICON_FILE_SAVE                = 6,
    ICON_FILE_EXPORT              = 7,
    ICON_FILE_ADD                 = 8,
    ICON_FILE_DELETE              = 9,
    ICON_FILETYPE_TEXT            = 10,
    ICON_FILETYPE_AUDIO           = 11,
    ICON_FILETYPE_IMAGE           = 12,
    ICON_FILETYPE_PLAY            = 13,
    ICON_FILETYPE_VIDEO           = 14,
    ICON_FILETYPE_INFO            = 15,
    ICON_FILE_COPY                = 16,
    ICON_FILE_CUT                 = 17,
    ICON_FILE_PASTE               = 18,
    ICON_CURSOR_HAND              = 19,
    ICON_CURSOR_POINTER           = 20,
    ICON_CURSOR_CLASSIC           = 21,
    ICON_PENCIL                   = 22,
    ICON_PENCIL_BIG               = 23,
    ICON_BRUSH_CLASSIC            = 24,
    ICON_BRUSH_PAINTER            = 25,
    ICON_WATER_DROP               = 26,
    ICON_COLOR_PICKER             = 27,
    ICON_RUBBER                   = 28,
    ICON_COLOR_BUCKET             = 29,
    ICON_TEXT_T                   = 30,
    ICON_TEXT_A                   = 31,
    ICON_SCALE                    = 32,
    ICON_RESIZE                   = 33,
    ICON_FILTER_POINT             = 34,
    ICON_FILTER_BILINEAR          = 35,
    ICON_CROP                     = 36,
    ICON_CROP_ALPHA               = 37,
    ICON_SQUARE_TOGGLE            = 38,
    ICON_SYMMETRY                 = 39,
    ICON_SYMMETRY_HORIZONTAL      = 40,
    ICON_SYMMETRY_VERTICAL        = 41,
    ICON_LENS                     = 42,
    ICON_LENS_BIG                 = 43,
    ICON_EYE_ON                   = 44,
    ICON_EYE_OFF                  = 45,
    ICON_FILTER_TOP               = 46,
    ICON_FILTER                   = 47,
    ICON_TARGET_POINT             = 48,
    ICON_TARGET_SMALL             = 49,
    ICON_TARGET_BIG               = 50,
    ICON_TARGET_MOVE              = 51,
    ICON_CURSOR_MOVE              = 52,
    ICON_CURSOR_SCALE             = 53,
    ICON_CURSOR_SCALE_RIGHT       = 54,
    ICON_CURSOR_SCALE_LEFT        = 55,
    ICON_UNDO                     = 56,
    ICON_REDO                     = 57,
    ICON_REREDO                   = 58,
    ICON_MUTATE                   = 59,
    ICON_ROTATE                   = 60,
    ICON_REPEAT                   = 61,
    ICON_SHUFFLE                  = 62,
    ICON_EMPTYBOX                 = 63,
    ICON_TARGET                   = 64,
    ICON_TARGET_SMALL_FILL        = 65,
    ICON_TARGET_BIG_FILL          = 66,
    ICON_TARGET_MOVE_FILL         = 67,
    ICON_CURSOR_MOVE_FILL         = 68,
    ICON_CURSOR_SCALE_FILL        = 69,
    ICON_CURSOR_SCALE_RIGHT_FILL  = 70,
    ICON_CURSOR_SCALE_LEFT_FILL   = 71,
    ICON_UNDO_FILL                = 72,
    ICON_REDO_FILL                = 73,
    ICON_REREDO_FILL              = 74,
    ICON_MUTATE_FILL              = 75,
    ICON_ROTATE_FILL              = 76,
    ICON_REPEAT_FILL              = 77,
    ICON_SHUFFLE_FILL             = 78,
    ICON_EMPTYBOX_SMALL           = 79,
    ICON_BOX                      = 80,
    ICON_BOX_TOP                  = 81,
    ICON_BOX_TOP_RIGHT            = 82,
    ICON_BOX_RIGHT                = 83,
    ICON_BOX_BOTTOM_RIGHT         = 84,
    ICON_BOX_BOTTOM               = 85,
    ICON_BOX_BOTTOM_LEFT          = 86,
    ICON_BOX_LEFT                 = 87,
    ICON_BOX_TOP_LEFT             = 88,
    ICON_BOX_CENTER               = 89,
    ICON_BOX_CIRCLE_MASK          = 90,
    ICON_POT                      = 91,
    ICON_ALPHA_MULTIPLY           = 92,
    ICON_ALPHA_CLEAR              = 93,
    ICON_DITHERING                = 94,
    ICON_MIPMAPS                  = 95,
    ICON_BOX_GRID                 = 96,
    ICON_GRID                     = 97,
    ICON_BOX_CORNERS_SMALL        = 98,
    ICON_BOX_CORNERS_BIG          = 99,
    ICON_FOUR_BOXES               = 100,
    ICON_GRID_FILL                = 101,
    ICON_BOX_MULTISIZE            = 102,
    ICON_ZOOM_SMALL               = 103,
    ICON_ZOOM_MEDIUM              = 104,
    ICON_ZOOM_BIG                 = 105,
    ICON_ZOOM_ALL                 = 106,
    ICON_ZOOM_CENTER              = 107,
    ICON_BOX_DOTS_SMALL           = 108,
    ICON_BOX_DOTS_BIG             = 109,
    ICON_BOX_CONCENTRIC           = 110,
    ICON_BOX_GRID_BIG             = 111,
    ICON_OK_TICK                  = 112,
    ICON_CROSS                    = 113,
    ICON_ARROW_LEFT               = 114,
    ICON_ARROW_RIGHT              = 115,
    ICON_ARROW_DOWN               = 116,
    ICON_ARROW_UP                 = 117,
    ICON_ARROW_LEFT_FILL          = 118,
    ICON_ARROW_RIGHT_FILL         = 119,
    ICON_ARROW_DOWN_FILL          = 120,
    ICON_ARROW_UP_FILL            = 121,
    ICON_AUDIO                    = 122,
    ICON_FX                       = 123,
    ICON_WAVE                     = 124,
    ICON_WAVE_SINUS               = 125,
    ICON_WAVE_SQUARE              = 126,
    ICON_WAVE_TRIANGULAR          = 127,
    ICON_CROSS_SMALL              = 128,
    ICON_PLAYER_PREVIOUS          = 129,
    ICON_PLAYER_PLAY_BACK         = 130,
    ICON_PLAYER_PLAY              = 131,
    ICON_PLAYER_PAUSE             = 132,
    ICON_PLAYER_STOP              = 133,
    ICON_PLAYER_NEXT              = 134,
    ICON_PLAYER_RECORD            = 135,
    ICON_MAGNET                   = 136,
    ICON_LOCK_CLOSE               = 137,
    ICON_LOCK_OPEN                = 138,
    ICON_CLOCK                    = 139,
    ICON_TOOLS                    = 140,
    ICON_GEAR                     = 141,
    ICON_GEAR_BIG                 = 142,
    ICON_BIN                      = 143,
    ICON_HAND_POINTER             = 144,
    ICON_LASER                    = 145,
    ICON_COIN                     = 146,
    ICON_EXPLOSION                = 147,
    ICON_1UP                      = 148,
    ICON_PLAYER                   = 149,
    ICON_PLAYER_JUMP              = 150,
    ICON_KEY                      = 151,
    ICON_DEMON                    = 152,
    ICON_TEXT_POPUP               = 153,
    ICON_GEAR_EX                  = 154,
    ICON_CRACK                    = 155,
    ICON_CRACK_POINTS             = 156,
    ICON_STAR                     = 157,
    ICON_DOOR                     = 158,
    ICON_EXIT                     = 159,
    ICON_MODE_2D                  = 160,
    ICON_MODE_3D                  = 161,
    ICON_CUBE                     = 162,
    ICON_CUBE_FACE_TOP            = 163,
    ICON_CUBE_FACE_LEFT           = 164,
    ICON_CUBE_FACE_FRONT          = 165,
    ICON_CUBE_FACE_BOTTOM         = 166,
    ICON_CUBE_FACE_RIGHT          = 167,
    ICON_CUBE_FACE_BACK           = 168,
    ICON_CAMERA                   = 169,
    ICON_SPECIAL                  = 170,
    ICON_LINK_NET                 = 171,
    ICON_LINK_BOXES               = 172,
    ICON_LINK_MULTI               = 173,
    ICON_LINK                     = 174,
    ICON_LINK_BROKE               = 175,
    ICON_TEXT_NOTES               = 176,
    ICON_NOTEBOOK                 = 177,
    ICON_SUITCASE                 = 178,
    ICON_SUITCASE_ZIP             = 179,
    ICON_MAILBOX                  = 180,
    ICON_MONITOR                  = 181,
    ICON_PRINTER                  = 182,
    ICON_PHOTO_CAMERA             = 183,
    ICON_PHOTO_CAMERA_FLASH       = 184,
    ICON_HOUSE                    = 185,
    ICON_HEART                    = 186,
    ICON_CORNER                   = 187,
    ICON_VERTICAL_BARS            = 188,
    ICON_VERTICAL_BARS_FILL       = 189,
    ICON_LIFE_BARS                = 190,
    ICON_INFO                     = 191,
    ICON_CROSSLINE                = 192,
    ICON_HELP                     = 193,
    ICON_FILETYPE_ALPHA           = 194,
    ICON_FILETYPE_HOME            = 195,
    ICON_LAYERS_VISIBLE           = 196,
    ICON_LAYERS                   = 197,
    ICON_WINDOW                   = 198,
    ICON_HIDPI                    = 199,
    ICON_FILETYPE_BINARY          = 200,
    ICON_HEX                      = 201,
    ICON_SHIELD                   = 202,
    ICON_FILE_NEW                 = 203,
    ICON_FOLDER_ADD               = 204,
    ICON_ALARM                    = 205,
    ICON_CPU                      = 206,
    ICON_ROM                      = 207,
    ICON_STEP_OVER                = 208,
    ICON_STEP_INTO                = 209,
    ICON_STEP_OUT                 = 210,
    ICON_RESTART                  = 211,
    ICON_BREAKPOINT_ON            = 212,
    ICON_BREAKPOINT_OFF           = 213,
    ICON_BURGER_MENU              = 214,
    ICON_CASE_SENSITIVE           = 215,
    ICON_REG_EXP                  = 216,
    ICON_FOLDER                   = 217,
    ICON_FILE                     = 218,
    ICON_SAND_TIMER               = 219,
    ICON_220                      = 220,
    ICON_221                      = 221,
    ICON_222                      = 222,
    ICON_223                      = 223,
    ICON_224                      = 224,
    ICON_225                      = 225,
    ICON_226                      = 226,
    ICON_227                      = 227,
    ICON_228                      = 228,
    ICON_229                      = 229,
    ICON_230                      = 230,
    ICON_231                      = 231,
    ICON_232                      = 232,
    ICON_233                      = 233,
    ICON_234                      = 234,
    ICON_235                      = 235,
    ICON_236                      = 236,
    ICON_237                      = 237,
    ICON_238                      = 238,
    ICON_239                      = 239,
    ICON_240                      = 240,
    ICON_241                      = 241,
    ICON_242                      = 242,
    ICON_243                      = 243,
    ICON_244                      = 244,
    ICON_245                      = 245,
    ICON_246                      = 246,
    ICON_247                      = 247,
    ICON_248                      = 248,
    ICON_249                      = 249,
    ICON_250                      = 250,
    ICON_251                      = 251,
    ICON_252                      = 252,
    ICON_253                      = 253,
    ICON_254                      = 254,
    ICON_255                      = 255




















proc rectangle*(x , y, width, height : int32 or float32 or float64): Rectangle =
  ## return any value in good "Rectangle" format
  result.x = x.float32
  result.y = y.float32
  result.width = width.float32
  result.height = height.float32


# Global gui state control functions
#RAYGUIAPI void GuiEnable(void);                                 // Enable gui controls (global state)
proc guiEnable*() {.cdecl, importc: "GuiEnable", header: rayguiHeader.}
#RAYGUIAPI void GuiDisable(void);                                // Disable gui controls (global state)
proc guiDisable*() {.cdecl, importc: "GuiDisable", header: rayguiHeader.}
#RAYGUIAPI void GuiLock(void);                                   // Lock gui controls (global state)
proc guiLock*() {.cdecl, importc: "GuiLock", header: rayguiHeader.}
#RAYGUIAPI void GuiUnlock(void);                                 // Unlock gui controls (global state)
proc guiUnlock*() {.cdecl, importc: "GuiUnlock", header: rayguiHeader.}
#RAYGUIAPI bool GuiIsLocked(void);                               // Check if gui is locked (global state)
proc guiIsLocked*(): bool {.cdecl, importc: "GuiIsLocked", header: rayguiHeader.}
#RAYGUIAPI void GuiSetAlpha(float alpha);                        // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
proc guiSetAlpha*(apha : float32) {.cdecl, importc: "GuiSetAlpha", header: rayguiHeader.}
#RAYGUIAPI void GuiSetState(int state);                          // Set gui state (global state)
proc guiSetState*(state: GuiState) {.cdecl, importc: "GuiSetState", header: rayguiHeader.}
#RAYGUIAPI int GuiGetState(void);                                // Get gui state (global state)
proc guiGetState*(): int32 {.cdecl, importc: "GuiGetState", header: rayguiHeader.}

#// Font set/get functions
#RAYGUIAPI void GuiSetFont(Font font);                           // Set gui custom font (global state)
proc guiSetFont*(font: Font) {.cdecl, importc: "GuiSetFont", header: rayguiHeader.}
#RAYGUIAPI Font GuiGetFont(void);                                // Get gui custom font (global state)
proc guiGetFont*(): Font {.cdecl, importc: "GuiGetFont", header: rayguiHeader.}

#// Style set/get functions
#RAYGUIAPI void GuiSetStyle(int control, int property, int value); // Set one style property
proc guiSetStyle*(control: int32, proprety: int32, value: int32) {.cdecl, importc: "GuiSetStyle", header: rayguiHeader.}
#proc guiSetStyle*(control: GuiControl ,proprety: GuiControlProperty, value: int32) {.cdecl, importc: "GuiSetStyle", header: rayguiHeader.}
proc guiSetStyle*(control: GuiControl ,
                  proprety: GuiControlProperty or GuiSliderProperty or GuiDefaultProperty, 
                   value: (int32 or GuiTextAlignment or GuiTextAlignmentVertical or GuiTextWrapMode))
                    {.cdecl, importc: "GuiSetStyle", header: rayguiHeader.}
#RAYGUIAPI int GuiGetStyle(int control, int property);           // Get one style property
proc guiGetStyle*(control: int32, proprety: int32): int32 {.cdecl, importc: "GuiGetStyle", header: rayguiHeader.}
proc guiGetStyle*(control: GuiControl, proprety: GuiDefaultProperty): int32 {.cdecl, importc: "GuiGetStyle", header: rayguiHeader.}




#// Styles loading functions
#RAYGUIAPI void GuiLoadStyle(const char *fileName);              // Load style file over global style variable (.rgs)
proc guiLoadStyle*(fileName: cstring) {.cdecl, importc: "GuiLoadStyle", header: rayguiHeader.}
#RAYGUIAPI void GuiLoadStyleDefault(void);                       // Load style default over global style
proc guiLoadStyleDefault*() {.cdecl, importc: "GuiLoadStyleDefault", header: rayguiHeader.}

#// Tooltips management functions
#RAYGUIAPI void GuiEnableTooltip(void);                          // Enable gui tooltips (global state)
#RAYGUIAPI void GuiDisableTooltip(void);                         // Disable gui tooltips (global state)
#RAYGUIAPI void GuiSetTooltip(const char *tooltip);              // Set tooltip string

#// Icons functionality
#RAYGUIAPI const char *GuiIconText(int iconId, const char *text); // Get text with icon id prepended (if supported)
proc guiIconText*(iconId: int32 or GuiIconName, text: cstring): cstring {.cdecl, importc: "GuiIconText", header: rayguiHeader, discardable.}
#if !defined(RAYGUI_NO_ICONS)
#RAYGUIAPI void GuiSetIconScale(int scale);                      // Set default icon drawing size
#RAYGUIAPI unsigned int *GuiGetIcons(void);                      // Get raygui icons data pointer
#RAYGUIAPI char **GuiLoadIcons(const char *fileName, bool loadIconsName); // Load raygui icons file (.rgi) into internal icons data
#RAYGUIAPI void GuiDrawIcon(int iconId, int posX, int posY, int pixelSize, Color color); // Draw icon using pixel size at specified position
#endif



# Controls
#----------------------------------------------------------------------------------------------------------
# Container/separator controls, useful for controls organization
#RAYGUIAPI int GuiWindowBox(rlRectangle bounds, const char *title);                                       // Window Box control, shows a window that can be closed
proc guiWindowBox*(bounds: Rectangle; title: cstring): bool {.cdecl, importc: "GuiWindowBox", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiGroupBox(rlRectangle bounds, const char *text);                                         // Group Box control with text name
proc guiGroupBox*(bounds: Rectangle; text: cstring) {.cdecl, importc: "GuiGroupBox", header: rayguiHeader.}
#RAYGUIAPI int GuiLine(rlRectangle bounds, const char *text);                                             // Line separator control, could contain text
proc guiLine*(bounds: Rectangle; text: cstring) {.cdecl, importc: "GuiLine", header: rayguiHeader.}
#RAYGUIAPI int GuiPanel(rlRectangle bounds, const char *text);                                            // Panel control, useful to group controls
proc guiPanel*(bounds: Rectangle, text: cstring) {.cdecl, importc: "GuiPanel", header: rayguiHeader.}
##  Panel control, useful to group controls
#RAYGUIAPI int GuiTabBar(rlRectangle bounds, const char **text, int count, int *active);                  // Tab Bar control, returns TAB to be closed or -1
#RAYGUIAPI int GuiScrollPanel(rlRectangle bounds, const char *text, rlRectangle content, Vector2 *scroll, rlRectangle *view); // Scroll Panel control
proc guiScrollPanel*(bounds: Rectangle; text: cstring, content: Rectangle, scroll: ptr Vector2, view: ptr Rectangle ): int32 
                      {.cdecl, importc: "GuiScrollPanel", header: rayguiHeader, discardable.}

# Basic controls set
#RAYGUIAPI int GuiLabel(rlRectangle bounds, const char *text);                                            // Label control, shows text
proc guiLabel*(bounds: Rectangle; text: cstring) {.cdecl, importc: "GuiLabel", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiButton(rlRectangle bounds, const char *text);                                           // Button control, returns true when clicked
proc guiButton*(bounds: Rectangle; text: cstring): bool {.cdecl, importc: "GuiButton", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiLabelButton(rlRectangle bounds, const char *text);                                      // Label button control, show true when clicked
proc guiLabelButton*(bounds: Rectangle; text: cstring): bool {.cdecl, importc: "GuiLabelButton", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiToggle(rlRectangle bounds, const char *text, bool *active);                             // Toggle Button control, returns true when active
proc guiToggle*(bounds: Rectangle; text: cstring; active: var bool): bool {.cdecl, importc: "GuiToggle", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiToggleGroup(rlRectangle bounds, const char *text, int *active);                         // Toggle Group control, returns active toggle index
proc guiToggleGroup*(bounds: Rectangle; text: cstring; active: var int32): int32 {.cdecl, importc: "GuiToggleGroup", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiToggleSlider(rlRectangle bounds, const char *text, int *active);                        // Toggle Slider control, returns true when clicked
proc guiToggleSlider*(bounds: Rectangle; text: cstring; active: var int32): int32 {.cdecl, importc: "GuiToggleSlider", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiCheckBox(rlRectangle bounds, const char *text, bool *checked);                          // Check Box control, returns true when active
proc guiCheckBox*(bounds: Rectangle; text: cstring; checked: var bool): bool {.cdecl, importc: "GuiCheckBox", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiComboBox(rlRectangle bounds, const char *text, int *active);                            // Combo Box control, returns selected item index
proc guiComboBox*(bounds: Rectangle; text: cstring; active: var int32): int32 {.cdecl, importc: "GuiComboBox", header: rayguiHeader, discardable.}


#RAYGUIAPI int GuiDropdownBox(rlRectangle bounds, const char *text, int *active, bool editMode);          // Dropdown Box control, returns selected item
proc guiDropdownBox*(bounds: Rectangle, text: cstring, active : var int32, editMode: bool): int32 {.cdecl, importc: "GuiDropdownBox", header:rayguiHeader, discardable.}
#RAYGUIAPI int GuiSpinner(rlRectangle bounds, const char *text, int *value, int minValue, int maxValue, bool editMode); // Spinner control, returns selected value
proc guiSpinner*(bounds: Rectangle, text: cstring, value: var int32, minValue: int32, maxValue: int32, editMode: bool): int32{.cdecl, importc: "GuiSpinner", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiValueBox(rlRectangle bounds, const char *text, int *value, int minValue, int maxValue, bool editMode); // Value Box control, updates input text with numbers
proc guiValueBox*(bounds: Rectangle, text: cstring, value: var int32, minValue: int32, maxValue: int32, editMode: bool):int32 {.cdecl, importc: "GuiValueBox", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiTextBox(rlRectangle bounds, char *text, int textSize, bool editMode);                   // Text Box control, updates input text
proc guiTextBox*(bounds: Rectangle, text: ptr cstring, textSize: int32, editMode: bool): int32 {.cdecl, importc: "GuiTextBox", header: rayguiHeader, discardable.}
  ## guiTextBox : use var text = create(cstring, nbdata) to allocate memory

#RAYGUIAPI int GuiSlider(rlRectangle bounds, const char *textLeft, const char *textRight, float *value, float minValue, float maxValue); // Slider control, returns selected value
proc guiSlider*(bounds: Rectangle, textLeft: cstring, textRight: cstring, value : var float32, minValue : float32, maxValue : float32): int32
                {.cdecl, importc: "GuiSlider", header: rayguiHeader, discardable.} 
#RAYGUIAPI int GuiSliderBar(rlRectangle bounds, const char *textLeft, const char *textRight, float *value, float minValue, float maxValue); // Slider Bar control, returns selected value
proc guiSliderBar*(bounds: Rectangle, textLeft: cstring, textRight: cstring, value : var float32, minValue : float32, maxValue : float32): int32
                {.cdecl, importc: "GuiSliderBar", header: rayguiHeader, discardable.} 
#RAYGUIAPI int GuiProgressBar(rlRectangle bounds, const char *textLeft, const char *textRight, float *value, float minValue, float maxValue); // Progress Bar control, shows current progress value
proc guiProgressBar*(bounds: Rectangle, textLeft: cstring, textRight: cstring, value : var float32, minValue : float32, maxValue : float32): int32
                {.cdecl, importc: "GuiProgressBar", header: rayguiHeader, discardable.} 
#RAYGUIAPI int GuiStatusBar(rlRectangle bounds, const char *text);                                        // Status Bar control, shows info text
proc guiStatusBar*(bounds: Rectangle, text: cstring): int32 {.cdecl, importc: "GuiStatusBar", header: rayguiHeader, discardable.} 
#RAYGUIAPI int GuiDummyRec(rlRectangle bounds, const char *text);                                         // Dummy control for placeholders
proc guiDummyRec*(bounds: Rectangle, text: cstring): int32 {.cdecl, importc: "GuiDummyRec", header: rayguiHeader, discardable.} 
#RAYGUIAPI int GuiGrid(rlRectangle bounds, const char *text, float spacing, int subdivs, Vector2 *mouseCell); // Grid control, returns mouse cell position
proc guiGrid*(bounds: Rectangle, text: cstring, spacing : float32, subdivs: int32, mouseCell: var Vector2): int32 {.cdecl, importc: "GuiGrid", header: rayguiHeader, discardable.} 


#Advance controls set
#RAYGUIAPI int GuiListView(rlRectangle bounds, const char *text, int *scrollIndex, int *active);          // List View control, returns selected list item index
proc guiListView*(bounds: Rectangle, text: cstring; scrollIndex: var int32, active: var int32): int32 {.cdecl, importc: "GuiListView", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiListViewEx(rlRectangle bounds, const char **text, int count, int *scrollIndex, int *active, int *focus); // List View with extended parameters
# @ not working const char **text ??? by ??
#proc guiListViewEx*(bounds: Rectangle, text: ptr UncheckedArray[cstring], count: int32, scrollIndex: var int32, active: var int32, focus: var int32): int32 {.cdecl, importc: "guiListViewEx", header: rayguiHeader, discardable.}
proc guiListViewEx*(bounds: Rectangle, text: cstringArray, count: int32, scrollIndex: int32, active: int32, focus: int32): int32 {.cdecl, importc: "guiListViewEx", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiMessageBox(rlRectangle bounds, const char *title, const char *message, const char *buttons); // Message Box control, displays a message
proc guiMessageBox*(bounds: Rectangle, title: cstring; message: cstring, buttons: cstring): int32 {.cdecl, importc: "GuiMessageBox", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiTextInputBox(rlRectangle bounds, const char *title, const char *message, const char *buttons, char *text, int textMaxSize, bool *secretViewActive); // Text Input Box control, ask for text, supports secret
proc guiTextInputBox*(bounds: Rectangle, title: cstring; message: cstring, buttons: cstring, textInput: ptr cstring, textMaxSize : int32, secretViewActive: ptr bool): int32 {.cdecl, importc: "GuiTextInputBox", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiColorPicker(rlRectangle bounds, const char *text, Color *color);                        // Color Picker control (multiple color controls)
proc guiColorPicker*(bounds: Rectangle, text: cstring; color: var Color): int32 {.cdecl, importc: "GuiColorPicker", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiColorPanel(rlRectangle bounds, const char *text, Color *color);                         // Color Panel control
proc guiColorPanel*(bounds: Rectangle, text: cstring, color: var Color): int32 {.cdecl, importc: "GuiColorPanel", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiColorBarAlpha(rlRectangle bounds, const char *text, float *alpha);                      // Color Bar Alpha control
proc guiColorBarAlpha*(bounds: Rectangle, text: cstring, apha: var float32): int32 {.cdecl, importc: "GuiColorBarAlpha", header: rayguiHeader, discardable.}
#RAYGUIAPI int GuiColorBarHue(rlRectangle bounds, const char *text, float *value);                        // Color Bar Hue control
#RAYGUIAPI int GuiColorPickerHSV(rlRectangle bounds, const char *text, Vector3 *colorHsv);                // Color Picker control that avoids conversion to RGB on each call (multiple color controls)
#RAYGUIAPI int GuiColorPanelHSV(rlRectangle bounds, const char *text, Vector3 *colorHsv);                 // Color Panel control that returns HSV color value, used by GuiColorPickerHSV()
#----------------------------------------------------------------------------------------------------------



# // Input required functions
# //-------------------------------------------------------------------------------
# static Vector2 GetMousePosition(void);
# static float GetMouseWheelMove(void);
# static bool IsMouseButtonDown(int button);
# static bool IsMouseButtonPressed(int button);
# static bool IsMouseButtonReleased(int button);

# static bool IsKeyDown(int key);
# static bool IsKeyPressed(int key);
# static int GetCharPressed(void);         // -- GuiTextBox(), GuiValueBox()
# //-------------------------------------------------------------------------------

# // Drawing required functions
# //-------------------------------------------------------------------------------
# static void DrawRectangle(int x, int y, int width, int height, Color color);        // -- GuiDrawRectangle()
# static void DrawRectangleGradientEx(rlRectangle rec, Color col1, Color col2, Color col3, Color col4); // -- GuiColorPicker()
# //-------------------------------------------------------------------------------

# // Text required functions
# //-------------------------------------------------------------------------------
# static Font GetFontDefault(void);                            // -- GuiLoadStyleDefault()
# static Font LoadFontEx(const char *fileName, int fontSize, int *codepoints, int codepointCount); // -- GuiLoadStyle(), load font

# static Texture2D LoadTextureFromImage(Image image);          // -- GuiLoadStyle(), required to load texture from embedded font atlas image
# static void SetShapesTexture(Texture2D tex, rlRectangle rec);  // -- GuiLoadStyle(), required to set shapes rec to font white rec (optimization)

# static char *LoadFileText(const char *fileName);             // -- GuiLoadStyle(), required to load charset data
# static void UnloadFileText(char *text);                      // -- GuiLoadStyle(), required to unload charset data

# static const char *GetDirectoryPath(const char *filePath);   // -- GuiLoadStyle(), required to find charset/font file from text .rgs

# static int *LoadCodepoints(const char *text, int *count);    // -- GuiLoadStyle(), required to load required font codepoints list
# static void UnloadCodepoints(int *codepoints);               // -- GuiLoadStyle(), required to unload codepoints list

# static unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize); // -- GuiLoadStyle()
# //-------------------------------------------------------------------------------

# // raylib functions already implemented in raygui
# //-------------------------------------------------------------------------------
# static Color GetColor(int hexValue);                // Returns a Color struct from hexadecimal value
# static int ColorToInt(Color color);                 // Returns hexadecimal value for a Color
# static bool CheckCollisionPointRec(Vector2 point, rlRectangle rec);   // Check if point is inside rlrectangle
# static const char *TextFormat(const char *text, ...);               // Formatting of text with variables to 'embed'
# static const char **TextSplit(const char *text, char delimiter, int *count);    // Split text into multiple strings
# static int TextToInteger(const char *text);         // Get integer value from text

# static int GetCodepointNext(const char *text, int *codepointSize);  // Get next codepoint in a UTF-8 encoded text
# static const char *CodepointToUTF8(int codepoint, int *byteSize);   // Encode codepoint into UTF-8 text (char array size returned as parameter)

# static void DrawRectangleGradientV(int posX, int posY, int width, int height, Color color1, Color color2);  // Draw rectangle vertical gradient
# //-------------------------------------------------------------------------------

# #endif      // RAYGUI_STANDALONE

# //----------------------------------------------------------------------------------
# // Module specific Functions Declaration
# //----------------------------------------------------------------------------------
# static void GuiLoadStyleFromMemory(const unsigned char *fileData, int dataSize);    // Load style from memory (binary only)

# static int GetTextWidth(const char *text);                      // Gui get text width using gui font and style
# static rlRectangle GetTextBounds(int control, rlRectangle bounds);  // Get text bounds considering control bounds
# static const char *GetTextIcon(const char *text, int *iconId);  // Get text icon if provided and move text cursor

# static void GuiDrawText(const char *text, rlRectangle textBounds, int alignment, Color tint);     // Gui draw text using default font
# static void GuiDrawRectangle(rlRectangle rec, int borderWidth, Color borderColor, Color color);   // Gui draw rectangle using default raygui style

# static const char **GuiTextSplit(const char *text, char delimiter, int *count, int *textRow);   // Split controls text into multiple strings
# static Vector3 ConvertHSVtoRGB(Vector3 hsv);                    // Convert color data from HSV to RGB
# static Vector3 ConvertRGBtoHSV(Vector3 rgb);                    // Convert color data from RGB to HSV

# static int GuiScrollBar(rlRectangle bounds, int value, int minValue, int maxValue);   // Scroll bar control, used by GuiScrollPanel()
# static void GuiTooltip(rlRectangle controlRec);                   // Draw tooltip using control rec position

# static Color GuiFade(Color color, float alpha);         // Fade color by an alpha factor




