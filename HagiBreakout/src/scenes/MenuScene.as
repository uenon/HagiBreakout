package scenes
{
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
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
			
			var titleImage:Sprite = TextField.getBitmapFont("Desyrel").createSprite(250, 50, "HagiBreakout", BitmapFont.NATIVE_SIZE, 0xFFFFFF);
			titleImage.x = (Constants.STAGE_WIDTH - 250) / 2;
			titleImage.y = 50;
            addChild(titleImage);
			
			var startButton:Button = new Button(Root.assets.getTexture("button_normal"), "Start");
			startButton.fontName = "Ubuntu";
			startButton.scaleX = 2;
			startButton.scaleY = 2;
			startButton.x = (Constants.STAGE_WIDTH - startButton.width) / 2;
			startButton.y = (Constants.STAGE_HEIGHT - startButton.height) / 2;
			startButton.addEventListener(Event.TRIGGERED, startButton_triggeredHandler);
			addChild(startButton);
			
			var settingsButton:Button = new Button(Root.assets.getTexture("button_normal"), "Settings");
			settingsButton.fontName = "Ubuntu";
			settingsButton.x = (Constants.STAGE_WIDTH - settingsButton.width) / 2;
			settingsButton.y = Constants.STAGE_HEIGHT * 0.7;
			settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			addChild(settingsButton);
			
			var githubButton:Button = new Button(Root.assets.getTexture("button_normal"), "GitHub");
			githubButton.fontName = "Ubuntu";
			githubButton.x = (Constants.STAGE_WIDTH - settingsButton.width) / 2;
			githubButton.y = settingsButton.y + settingsButton.height + 10;
			githubButton.addEventListener(Event.TRIGGERED, githubButton_triggeredHandler);
			addChild(githubButton);
        }
		
		private function startButton_triggeredHandler():void
		{
			dispatchEventWith(START_GAME, true);
		}
		
		private function settingsButton_triggeredHandler():void
		{
			dispatchEventWith(OPEN_SETTINGS, true);
		}
		
		private function githubButton_triggeredHandler():void
		{
			navigateToURL(new URLRequest("https://github.com/CreateSomethingWithStarling/HagiBreakout"));
		}
    }
}