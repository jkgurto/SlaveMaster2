﻿package game.library.states {        import fl.controls.Button;	import fl.controls.Label;		import flash.display.Stage;	import flash.events.MouseEvent;	import flash.text.AntiAliasType;	import flash.text.TextFormat;	import flash.text.TextFieldAutoSize;        import game.library.states.MenuState;        public class StartState extends MenuState {        		private var startLabel:Label;		private var startButton:Button;		private var creditsButton:Button;		private var helpButton:Button;		        public function StartState(m:Main) {            super(m);                        reset();        }                override public function reset():void {                        // Title			startLabel = new Label();						startLabel.autoSize = TextFieldAutoSize.LEFT;			startLabel.textField.antiAliasType = AntiAliasType.NORMAL;			startLabel.setStyle("embedFonts", true);			startLabel.setStyle("textFormat", labelFormat);						startLabel.text = "Slave Master";						startLabel.x = LABEL_X - (startLabel.width * 0.5);			startLabel.y = TOP_LABEL_Y - (startLabel.height * 0.5);						startLabel.width = INFO_WIDTH;						// Start			startButton = new Button();						startButton.textField.antiAliasType = AntiAliasType.NORMAL;			startButton.setStyle("embedFonts", true);			startButton.setStyle("textFormat", buttonFormat);						startButton.label = "Start";						startButton.x = LABEL_X - (startButton.width * 0.5);			startButton.y = startLabel.y + startLabel.height + BUTTON_SPACE_Y;						// Credits			creditsButton = new Button();						creditsButton.textField.antiAliasType = AntiAliasType.NORMAL;			creditsButton.setStyle("embedFonts", true);			creditsButton.setStyle("textFormat", buttonFormat);						creditsButton.label = "Credits";						creditsButton.x = startButton.x;			creditsButton.y = startButton.y + startButton.height + BUTTON_SPACE_Y;						// Help			helpButton = new Button();						helpButton.textField.antiAliasType = AntiAliasType.NORMAL;			helpButton.setStyle("embedFonts", true);			helpButton.setStyle("textFormat", buttonFormat);						helpButton.label = "Help";						helpButton.x = creditsButton.x;			helpButton.y = creditsButton.y + creditsButton.height + BUTTON_SPACE_Y;        }                override public function enter():void {						stage.addChild(startLabel);						// Start			startButton.addEventListener(MouseEvent.CLICK, startButtonClicked);			stage.addChild(startButton);						// Credits			creditsButton.addEventListener(MouseEvent.CLICK, creditsButtonClicked);			stage.addChild(creditsButton);						// Help			helpButton.addEventListener(MouseEvent.CLICK, helpButtonClicked);			stage.addChild(helpButton);        }                override public function exit():void {            stage.removeChild(startLabel);						startButton.removeEventListener(MouseEvent.CLICK, startButtonClicked);			stage.removeChild(startButton);						creditsButton.removeEventListener(MouseEvent.CLICK, creditsButtonClicked);			stage.removeChild(creditsButton);						helpButton.removeEventListener(MouseEvent.CLICK, helpButtonClicked);			stage.removeChild(helpButton);        }                private function startButtonClicked(event:MouseEvent):void {			_main.currentState = "PlayState";		}                private function helpButtonClicked(event:MouseEvent):void {			_main.currentState = "HelpState";		}                private function creditsButtonClicked(event:MouseEvent):void {			_main.currentState = "CreditsState";		}    }}