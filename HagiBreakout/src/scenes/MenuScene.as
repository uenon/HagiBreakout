package scenes
{
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    
    /** The Menu shows the logo of the game and a start button that will, once triggered, 
     *  start the actual game. In a real game, it will probably contain several buttons and
     *  link to several screens (e.g. a settings screen or the credits). If your menu contains
     *  a lot of logic, you could use the "Feathers" library to make your life easier. */
    public class MenuScene extends Sprite
    {
        public static const START_GAME:String = "startGame";
        public static const OPEN_SETTINGS:String = "openSettings";
        
        public function MenuScene()
        {
			addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init():void
        {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
            var textField:TextField = new TextField(250, 50, "HagiBreakout", 
                "Desyrel", BitmapFont.NATIVE_SIZE, 0xffffff);
            textField.x = (Constants.STAGE_WIDTH - textField.width) / 2;
            textField.y = 50;
            addChild(textField);
			
			var button:Button = new Button(Root.assets.getTexture("button_normal"), "Start");
			button.fontName = "Ubuntu";
			button.x = (Constants.STAGE_WIDTH - button.width) / 2;
			button.y = Constants.STAGE_HEIGHT * 0.75;
			button.addEventListener(Event.TRIGGERED, onButtonTriggered);
			addChild(button);
			
			var settingsButton:Button = new Button(Root.assets.getTexture("button_normal"), "Settings");
			settingsButton.fontName = "Ubuntu";
			settingsButton.x = (Constants.STAGE_WIDTH - settingsButton.width) / 2;
			settingsButton.y = button.y + button.height + 10;
			settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			addChild(settingsButton);
        }
		
		private function settingsButton_triggeredHandler():void
		{
			dispatchEventWith(OPEN_SETTINGS, true);
		}
		
        private function onButtonTriggered():void
        {
            dispatchEventWith(START_GAME, true, "classic");
        }
    }
}