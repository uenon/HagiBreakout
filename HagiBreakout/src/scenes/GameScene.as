package scenes 
{
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Circle;
    import nape.shape.Polygon;
    import nape.space.Space;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    /** The Game class represents the actual game. In this scaffold, it just displays a 
     *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
    public class GameScene extends Sprite
    {
		public static const GAME_OVER:String = "gameOver";
		
		
		public function GameScene()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private var mBird:Image;
		private var space:Space;
		
		private var napeDebugImage:NapeDebugImage;
		
		private function init(event:Event):void
		{
			if (Root.settings.napeDebugVisible)
				napeDebugImage = new NapeDebugImage(stage.stageWidth, stage.stageHeight);
			
			space = new Space(new Vec2(0, 1000));
			
			var floor:Body = new Body(BodyType.STATIC);
			floor.shapes.add( new Polygon(Polygon.rect(0, Constants.STAGE_HEIGHT, Constants.STAGE_WIDTH, 20)));
			floor.space = space;
			
			addBall();
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event, passedTime:Number):void
		{
			space.step(passedTime);
			
			if (Math.random() < 1 / Root.settings.frameRate)
				addBall();
			
			space.liveBodies.foreach(updateGraphics);
			
			if (napeDebugImage)
			{
				napeDebugImage.update(space);
				
				// napeDebugImageを最前面に表示する
				addChild(napeDebugImage);
			}
		}
		
		private function addBall():void
		{
			var mBird:Image = new Image(Root.assets.getTexture("starling_rocket"));
			mBird.pivotX = mBird.width / 2;
			mBird.pivotY = mBird.height / 2;;
			mBird.width = 100;
			mBird.height = 100;
			addChild(mBird);
			mBird.touchable = true;
			mBird.addEventListener(TouchEvent.TOUCH, onBirdTouched);
			
			var ball:Body = new Body(BodyType.DYNAMIC, new Vec2(Math.random()*Constants.STAGE_WIDTH, 0));
			ball.shapes.add(new Circle(50, null, new Material(0.7)));
			ball.space = space;
			ball.userData.graphic = mBird;
		}
		
		private function updateGraphics(b:Body):void
		{
		//	trace(b.position.x, b.position.y);
			
			b.userData.graphic.x = b.position.x;
			b.userData.graphic.y = b.position.y;
			b.userData.graphic.rotation = b.rotation;
		}
		
        private function onBirdTouched(event:TouchEvent):void
        {
            if (event.getTouch(this, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
                Starling.juggler.removeTweens(mBird);
                dispatchEventWith(GAME_OVER, true, 100);
            }
        }
    }
}

import flash.display.BitmapData;

import nape.space.Space;
import nape.util.BitmapDebug;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * Napeのデバッグ表示をStarlingで行う便利クラス
 * 
 * Napeのデバッグ表示は通常DisplayListで行うので、以下のようにnativeOverlay追加する手もあるが、
 * これではデバッグ表示の描画が1フレーム遅れてしまう。
 * 
 * //　init時
 * napeBitmapDebug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0x333333, true);
 * Starling.current.nativeOverlay.addChild(napeBitmapDebug.display);
 * 
 * //　roop内で
 * napeBitmapDebug.clear();
 * napeBitmapDebug.draw(space);
 * napeBitmapDebug.flush();
 * 
 * @see http://napephys.com/samples.html#as3-BasicSimulation
 */
class NapeDebugImage extends Sprite
{
	public function NapeDebugImage(imageWidth:Number, imageHeight:Number)
	{
		super();
		
		touchable = false;
		
		napeBitmapDebug = new BitmapDebug(imageWidth, imageHeight, 0x333333, true);
		debugBitmapData = new BitmapData(imageWidth, imageHeight);
	}
	
	private var imageWidth:Number;
	private var imageHeight:Number;
	
	private var napeBitmapDebug:BitmapDebug;
	private var debugBitmapData:BitmapData;
	private var debugImage:Image;
	
	public function update(space:Space):void
	{
		napeBitmapDebug.clear();
		napeBitmapDebug.draw(space);
		napeBitmapDebug.flush();
		
		debugBitmapData.fillRect(debugBitmapData.rect, 0x00000000);
		debugBitmapData.draw(napeBitmapDebug.display);
		
		var debugTexure:Texture = Texture.fromBitmapData(debugBitmapData);
		
		if (!debugImage)
		{
			debugImage = new Image(debugTexure);
			addChild(debugImage);
		}
		else
		{
			debugImage.texture.dispose();
			debugImage.texture = debugTexure;
		}
	}
	
	public function clear():void
	{
		napeBitmapDebug.clear();
		napeBitmapDebug.flush();
		debugImage.texture.dispose();
		removeChild(debugImage, true);
	}
	
	override public function dispose():void
	{
		clear();
		debugBitmapData.dispose();
		super.dispose();
	}
}