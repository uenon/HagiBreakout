package
{
    import data.Settings;
    
    import scenes.GameScene;
    import scenes.MenuScene;
    import scenes.SettingsScene;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    
    import utils.AssetManager;
    import utils.ProgressBar;

    /** The Root class is the topmost display object in your game. It loads all the assets
     *  and displays a progress bar while this is happening. Later, it is responsible for
     *  switching between game and menu. For this, it listens to "START_GAME" and "GAME_OVER"
     *  events fired by the Menu and Game classes. Keep this class rather lightweight: it 
     *  controls the high level behaviour of your game. */
    public class Root extends Sprite
    {
		private static var sTheme:FeathersTheme;
		private static var sSettings:Settings;
		private static var sAssets:AssetManager;
        
        private var mActiveScene:Sprite;
		
        public function Root()
        {
			addEventListener(MenuScene.START_GAME, onStartGame);
			addEventListener(MenuScene.OPEN_SETTINGS,  onOpenSetting);
			addEventListener(SettingsScene.CLOSE_SETTINGS,  onCloseSetting);
            addEventListener(GameScene.GAME_OVER,  onGameOver);
            
            // not more to do here -- Startup will call "start" immediately.
        }
		
        public function start(background:Texture, assets:AssetManager):void
        {
			sTheme = new FeathersTheme(stage);
			
			sSettings = new Settings();
			Starling.current.showStats = sSettings.statsVisible;
			Starling.current.nativeStage.frameRate = sSettings.frameRate;
			
            // the asset manager is saved as a static variable; this allows us to easily access
            // all the assets from everywhere by simply calling "Root.assets"
            sAssets = assets;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            
            addChild(new Image(background));
            
            // The AssetManager contains all the raw asset data, but has not created the textures
            // yet. This takes some time (the assets might be loaded from disk or even via the
            // network), during which we display a progress indicator. 
            
            var progressBar:ProgressBar = new ProgressBar(175, 20);
            progressBar.x = (background.width  - progressBar.width)  / 2;
            progressBar.y = (background.height - progressBar.height) / 2;
            progressBar.y = background.height * 0.85;
            addChild(progressBar);
            
            assets.loadQueue(function onProgress(ratio:Number):void
            {
                progressBar.ratio = ratio;
                
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay. 
                
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
                        progressBar.removeFromParent(true);
                        showScene(MenuScene);
                    }, 0.15);
            });
        }
		
		private function onOpenSetting():void
		{
			showScene(SettingsScene);
		}
		
		private function onCloseSetting():void
		{
			showScene(MenuScene);
		}
        
        private function onGameOver(event:Event, score:int):void
        {
            trace("Game Over! Score: " + score);
            showScene(MenuScene);
        }
        
        private function onStartGame():void
        {
            showScene(GameScene);
        }
        
        private function showScene(screen:Class):void
        {
            if (mActiveScene) mActiveScene.removeFromParent(true);
            mActiveScene = new screen();
            addChild(mActiveScene);
        }
		
		public static function get theme():FeathersTheme { return sTheme; }
		public static function get settings():Settings { return sSettings; }
        public static function get assets():AssetManager { return sAssets; }
    }
}