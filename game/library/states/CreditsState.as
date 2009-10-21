﻿package game.library.states {        import fl.controls.Button;	import fl.controls.Label;		import flash.events.MouseEvent;	import flash.text.TextFieldAutoSize;        import game.library.states.MenuState;    import game.library.states.Text;        public class CreditsState extends MenuState {                private var creditsLabel:Label;		private var creditsInfoLabel:Label;		private var creditsBackButton:Button;		        public function CreditsState(m:Main) {            super(m);                        reset();        }                override public function reset():void {            // Title			creditsLabel = new Label();						creditsLabel.autoSize = TextFieldAutoSize.CENTER;			creditsLabel.setStyle("textFormat", labelFormat);						creditsLabel.text = "Credits";						creditsLabel.x = LABEL_X - (creditsLabel.width * 0.5);			creditsLabel.y = TOP_LABEL_Y - (creditsLabel.height * 0.5);						// Text			creditsInfoLabel = new Label();						creditsInfoLabel.autoSize = TextFieldAutoSize.CENTER;			creditsInfoLabel.setStyle("textFormat", infoLabelFormat);						creditsInfoLabel.text = Text.CREDITS_STRING;						creditsInfoLabel.width = INFO_WIDTH;			creditsInfoLabel.height = INFO_HEIGHT;						creditsInfoLabel.x = LABEL_X - (creditsInfoLabel.width * 0.5);			creditsInfoLabel.y = creditsLabel.y + creditsLabel.height + BUTTON_SPACE_Y;						// Back			creditsBackButton = new Button();						creditsBackButton.setStyle("textFormat", buttonFormat);						creditsBackButton.label = "Back";						creditsBackButton.x = LABEL_X - (creditsBackButton.width * 0.5);			creditsBackButton.y = creditsInfoLabel.y + creditsInfoLabel.height + BUTTON_SPACE_Y;        }                override public function enter():void {            stage.addChild(creditsLabel);            stage.addChild(creditsInfoLabel);            stage.addChild(creditsBackButton);            creditsBackButton.addEventListener(MouseEvent.CLICK, creditsBackButtonClicked);        }                override public function exit():void {            stage.removeChild(creditsLabel);			stage.removeChild(creditsInfoLabel);						creditsBackButton.removeEventListener(MouseEvent.CLICK, creditsBackButtonClicked);			stage.removeChild(creditsBackButton);        }                private function creditsBackButtonClicked(event:MouseEvent):void {			_main.currentState = "StartState";		}    }}