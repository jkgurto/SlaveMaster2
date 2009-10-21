package game.library.states {
    
    import fl.controls.Button;
	import fl.controls.Label;
	
	import flash.events.MouseEvent;
    
    import game.library.states.MenuState;
    import game.library.states.Text;
    
    import mx.core.Application;
    
    public class HelpState extends MenuState {
        
        private var helpLabel:Label;
		private var helpInfoLabel:Label;
		private var helpBackButton:Button;
		
        public function HelpState(m:Main) {
            super(m);
            
            reset();
        }
        
        override public function reset():void {
            // Title
			helpLabel = new Label();
			
			//helpLabel.autoSize = TextFieldAutoSize.CENTER;
			//helpLabel.setStyle("textFormat", labelFormat);
			helpLabel.setStyle("fontFamily", labelFormat.font);
			helpLabel.setStyle("color", labelFormat.color);
			helpLabel.setStyle("size", labelFormat.size);
			
			helpLabel.text = "Help";
			
			helpLabel.x = LABEL_X - (helpLabel.width * 0.5);
			helpLabel.y = TOP_LABEL_Y - (helpLabel.height * 0.5);
			
			// Text
			helpInfoLabel = new Label();
			
			//helpInfoLabel.autoSize = TextFieldAutoSize.CENTER;
			//helpInfoLabel.setStyle("textFormat", infoLabelFormat);
			helpInfoLabel.setStyle("fontFamily", infoLabelFormat.font);
			helpInfoLabel.setStyle("color", infoLabelFormat.color);
			helpInfoLabel.setStyle("size", infoLabelFormat.size);
			
			helpInfoLabel.text = Text.HELP_STRING;
			
			helpInfoLabel.width = INFO_WIDTH;
			helpInfoLabel.height = INFO_HEIGHT;
			
			helpInfoLabel.x = LABEL_X - (helpInfoLabel.width * 0.5);
			helpInfoLabel.y = helpLabel.y + helpLabel.height + BUTTON_SPACE_Y;
			
			// Back
			helpBackButton = new Button();
			
			//helpBackButton.setStyle("textFormat", buttonFormat);
			helpBackButton.setStyle("fontFamily", buttonFormat.font);
			helpBackButton.setStyle("color", buttonFormat.color);
			helpBackButton.setStyle("size", buttonFormat.size);
			
			helpBackButton.label = "Back";
			
			helpBackButton.x = LABEL_X - (helpBackButton.width * 0.5);
			helpBackButton.y = helpInfoLabel.y + helpInfoLabel.height + BUTTON_SPACE_Y;
        }
        
        override public function enter():void {
            Application.application.canvas.addChild(helpLabel);
            Application.application.canvas.addChild(helpInfoLabel);
            Application.application.canvas.addChild(helpBackButton);
            helpBackButton.addEventListener(MouseEvent.CLICK, helpBackButtonClicked);
        }
        
        override public function exit():void {
            Application.application.canvas.removeChild(helpLabel);
			Application.application.canvas.removeChild(helpInfoLabel);
			
			helpBackButton.removeEventListener(MouseEvent.CLICK, helpBackButtonClicked);
			Application.application.canvas.removeChild(helpBackButton);
        }
        
        private function helpBackButtonClicked(event:MouseEvent):void {
			_main.currentState = "StartState";
		}

    }
}