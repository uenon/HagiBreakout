package
{
	import feathers.display.TiledImage;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	public class FeathersTheme extends MetalWorksMobileTheme
	{
		public function FeathersTheme(root:DisplayObjectContainer, scaleToDPI:Boolean=true)
		{
			super(root, scaleToDPI);
		}
		
		override protected function initializeRoot():void
		{
			this.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this.root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
		}
		
		public function get feathersBackground():Sprite
		{
			if (!primaryBackground)
			{
				this.primaryBackground = new TiledImage(this.primaryBackgroundTexture);
				this.primaryBackground.width = root.stage.stageWidth;
				this.primaryBackground.height = root.stage.stageHeight;
			}
			return primaryBackground;
		}
	}
}