package
{
    import flash.text.TextFormat;
    
    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.text.BitmapFontTextRenderer;
    import feathers.core.ITextRenderer;
    import feathers.text.BitmapFontTextFormat;
    
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.TextureSmoothing;
    
    /** The Menu shows the logo of the game and a start button that will, once triggered, 
     *  start the actual game. In a real game, it will probably contain several buttons and
     *  link to several screens (e.g. a settings screen or the credits). If your menu contains
     *  a lot of logic, you could use the "Feathers" library to make your life easier. */
    public class Menu extends Sprite
    {
        public static const START_GAME:String = "startGame";
        
        public function Menu()
        {
			addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init():void
        {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			/*
            var textField:TextField = new TextField(250, 50, "Game Scaffold", 
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
			*/
			
			// 試しにFeathersのLabelとButtonに置換えてみた。
			
			var label:Label = new Label();
			label.text = "Game Scaffold";
			addChild(label);
			label.textRendererFactory = function():ITextRenderer { return new BitmapFontTextRenderer() };
			label.textRendererProperties.textFormat = new BitmapFontTextFormat("Desyrel");
			label.textRendererProperties.smoothing = TextureSmoothing.NONE;
			label.validate();
			label.x = (Constants.STAGE_WIDTH - label.width) / 2;
			label.y = 50;
			
			var button:Button = new Button();
			button.label = "Start";
			addChild(button);
			button.defaultLabelProperties.textFormat = new TextFormat("Ubuntu", 24, 0xCC0000);
			button.defaultLabelProperties.embedFonts = true;
			button.validate();
			button.x = (Constants.STAGE_WIDTH - button.width) / 2;
			button.y = Constants.STAGE_HEIGHT * 0.75;
			button.addEventListener(Event.TRIGGERED, onButtonTriggered);
        }
        
        private function onButtonTriggered():void
        {
            dispatchEventWith(START_GAME, true, "classic");
        }
    }
}