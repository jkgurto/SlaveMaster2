package game.library.states {
    
    import flash.text.TextFormat;
    
    import game.library.states.BaseState;
    
    import Main;
    
    public class MenuState extends BaseState {
        
        public static const TOP_LABEL_Y:Number = 150;
		public static const LABEL_X:Number = 400;
		
		public static const BUTTON_SPACE_Y:Number = 22;
		
		public static const INFO_WIDTH:Number = 300;
		public static const INFO_HEIGHT:Number = 200;
		
		public static const LABEL_COLOUR:Number = 0x000000;
		public static const INFO_LABEL_COLOUR:Number = 0x000000;
		public static const BUTTON_COLOUR:Number = 0x000000;
		
		public static const LABEL_SIZE:Number = 24;
		public static const INFO_LABEL_SIZE:Number = 18;
		public static const BUTTON_SIZE:Number = 12;
        
        protected var labelFormat:TextFormat;
		protected var infoLabelFormat:TextFormat;
		protected var buttonFormat:TextFormat;
		
        public function MenuState(m:Main) {
            super(m);
            
            // Formats
			labelFormat = new TextFormat();
			labelFormat.font = "ZapfinoRegular";
			labelFormat.color = LABEL_COLOUR;
			labelFormat.size = LABEL_SIZE;
			
			infoLabelFormat = new TextFormat();
			infoLabelFormat.font = "TimesNewRomanRegular";
			infoLabelFormat.color = INFO_LABEL_COLOUR;
			infoLabelFormat.size = INFO_LABEL_SIZE;
			
			buttonFormat = new TextFormat();
			buttonFormat.font = "TimesNewRomanRegular";
			buttonFormat.color = BUTTON_COLOUR;
			buttonFormat.size = BUTTON_SIZE;
        }
        
    }
}