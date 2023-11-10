#!/bin/bash

####################################################################################
##
##                              Create a Dialog
##                      Swift Dialog notification builder
##                          Created by Trenton Cook
##
####################################################################################

echo ""
echo "##########################################"
echo "##        Script Initializing...          "
echo "##########################################"
echo " "

## Enable/Disable a second notification page which can be adjust under lines 78, 109, & 155
page2Status="${4:-"false"}"                        # Parameter 4: Enable Page 2? [ Default : False ]

##########################################
## DIALOG NOTIFICATION PROCESSING
##########################################

## Check https://github.com/bartreardon/swiftDialog/wiki for a full list of commands and customizations for SwiftDialog
echo "-- Grabbing Dialog binary..."
dialogBinary="/usr/local/bin/dialog"

##########################################
## Page 1 Variables
##########################################

echo "-- Setting Page 1 variables..."
page1button1text="Button 1"
page1button2text="Button 2"
page1infotext="Info Button"
page1title="Page 1"
page1message="Adjust this window under 'Page 1 Variables' and 'Page 1 Configuration'"
page1Icon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path )

##########################################
## Page 2 Variables
##########################################

if [[ "${page2Status}" == "true" ]]; then
echo "-- Setting Page 2 variables..."
    page2button1text="Button 1"
    page2button2text="Button 2"
    page2infotext="Info Button"
    page2title="Page 2"
    page2message="Adjust this window under 'Page 2 Variables' and 'Page 2 Configuration'"
    page2Icon=$( defaults read /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path )
fi

##########################################
## Page 1 Configuration
##########################################

echo "-- Writing Page 1 data..."
page1Config="$dialogBinary \
--title \"$page1title\" \
--message \"$page1message\" \
--icon \"$page1Icon\" \
--button1text \"$page1button1text\" \
--button2text \"$page1button2text\" \
--infobuttontext \"$page1infotext\" \
--titlefont 'size=38' \
--messagefont 'size=18' \
--iconsize '200' \
--quitoninfo \
--height '300' \
--ontop \
"

##########################################
## Page 2 Configuration
##########################################

if [[ "${page2Status}" == "true" ]]; then
    echo "-- Writing Page 2 data..."
    page2Config="$dialogBinary \
    --title \"$page2title\" \
    --message \"$page2message\" \
    --icon \"$page2Icon\" \
    --button1text \"$page2button1text\" \
    --button2text \"$page2button2text\" \
    --infobuttontext \"$page2infotext\" \
    --titlefont 'size=38' \
    --messagefont 'size=18' \
    --iconsize '200' \
    --quitoninfo \
    --height '300' \
    --ontop \
    "
fi

##########################################
## Display Page 1 and evaluate returns
##########################################

## Run the Dialog for Page 1
echo "-- Running Dialog for page 1..."
echo "-- Waiting for input..."
eval "${page1Config}"

## Run commands based off button returns (Page 1)
case $? in
    ## Button 1 Return
    0)
    echo "-- User Pressed $page1button1text --"
    ;;
    ## Button 2 Return
    2)
    echo "-- User Pressed $page1button2text --"
    ;;
    ## Info Button Return
    3)
    echo "-- User Pressed $page1infotext --"
    ;;
esac

##########################################
## Display Page 2 and evaluate returns
##########################################

## Run the Dialog for Page 2
if [[ "${page2Status}" == "true" ]]; then
    echo "-- Running Dialog for page 2..."
    echo "-- Waiting for input..."
    eval "${page2Config}"

    ## Run commands based off button returns (Page 2)
    case $? in 
        ## Button 1 Return
        0)
        echo "-- User Pressed $page2button1text --"
        ;;
        ## Button 2 Return
        2)
        echo "-- User Pressed $page2button2text --"
        ;;
        ## InfoButton Return
        3)
        echo "-- User Pressed $page2infotext --"
        ;;
    esac
fi

## Notify of finalization
echo ""
echo "##########################################"
echo "##           Script Complete!             "
echo "##########################################"
echo " "
