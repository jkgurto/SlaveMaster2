package game.library.states {
    
    import fl.controls.Button;
	import fl.controls.Label;
	
	import flash.events.MouseEvent;
    
    import game.library.states.MenuState;
    
    import mx.core.Application;
    
    public class NextLevelState extends MenuState {
        
        private var pausedLabel:Label;
		private var pausedInfoLabel:Label;
		private var continueButton:Button;
		
		private var _level:int = 0;
		
        public function NextLevelState(m:Main) {
            super(m);
            
            reset();
        }
        
        public function set level(value:int):void {
            _level = value;
        }
        
        override public function reset():void {
            // Title
			pausedLabel = new Label();
			
			//pausedLabel.autoSize = TextFieldAutoSize.CENTER;
			//pausedLabel.setStyle("textFormat", labelFormat);
			pausedLabel.setStyle("fontFamily", labelFormat.font);
			pausedLabel.setStyle("color", labelFormat.color);
			pausedLabel.setStyle("size", labelFormat.size);
			
			pausedLabel.text = "Next Level";
			
			pausedLabel.x = LABEL_X - (pausedLabel.width * 0.5);
			pausedLabel.y = TOP_LABEL_Y - (pausedLabel.height * 0.5);
			
			// Text
			pausedInfoLabel = new Label();
			
			//pausedInfoLabel.autoSize = TextFieldAutoSize.CENTER;
			//pausedInfoLabel.setStyle("textFormat", infoLabelFormat);
			pausedInfoLabel.setStyle("fontFamily", infoLabelFormat.font);
			pausedInfoLabel.setStyle("color", infoLabelFormat.color);
			pausedInfoLabel.setStyle("size", infoLabelFormat.size);
			
			// Use +1 so game starts from 1 instead of 0
			pausedInfoLabel.text = "Level " + (_level + 1);
			
			pausedInfoLabel.x = LABEL_X - (pausedInfoLabel.width * 0.5);
			pausedInfoLabel.y = pausedLabel.y + pausedLabel.height + BUTTON_SPACE_Y;
			
			// Back
			continueButton = new Button();
			
			//continueButton.setStyle("textFormat", buttonFormat);
			continueButton.setStyle("fontFamily", buttonFormat.font);
			continueButton.setStyle("color", buttonFormat.color);
			continueButton.setStyle("size", buttonFormat.size);
			
			continueButton.label = "Continue";
			
			continueButton.x = LABEL_X - (continueButton.width * 0.5);
			continueButton.y = pausedInfoLabel.y + pausedInfoLabel.height + BUTTON_SPACE_Y;
        }
        
        override public function enter():void {
            Application.application.canvas.addChild(pausedLabel);
            Application.application.canvas.addChild(pausedInfoLabel);
            Application.application.canvas.addChild(continueButton);
            continueButton.addEventListener(MouseEvent.CLICK, continueButtonClicked);
        }
        
        override public function exit():void {
            Application.application.canvas.removeChild(pausedLabel);
			Application.application.canvas.removeChild(pausedInfoLabel);
			
			continueButton.removeEventListener(MouseEvent.CLICK, continueButtonClicked);
			Application.application.canvas.removeChild(continueButton);
        }
        
        private function continueButtonClicked(event:MouseEvent):void {
			_main.currentState = "PlayState";
		}

    }
}
