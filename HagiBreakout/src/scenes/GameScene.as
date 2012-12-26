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
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

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

		private var handle:Body;
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (Root.settings.napeDebugVisible)
				napeDebugImage = new NapeDebugImage(stage.stageWidth, stage.stageHeight);
			
			var background:Image = new Image(Root.assets.getTexture("game_bg"));
			addChild(background);
			
			var wallImage:Image = new Image(Root.assets.getTexture("game_wall"));
			addChild(wallImage);
			
			space = new Space(new Vec2(0, 1000));
			
			var wall:Body = new Body(BodyType.STATIC);
			wall.shapes.add(new Polygon(Polygon.rect(0, 0, Constants.STAGE_WIDTH, 10)));
			wall.shapes.add(new Polygon(Polygon.rect(0, 0, 10, Constants.STAGE_HEIGHT)));
			wall.shapes.add(new Polygon(Polygon.rect(Constants.STAGE_WIDTH, 0, -10, Constants.STAGE_HEIGHT)));
			wall.space = space;
			
			var blockSmallImage:Image = new Image(Root.assets.getTexture("game_block_small"));
			blockSmallImage.x = Constants.STAGE_WIDTH / 2 - 50;
			blockSmallImage.y = Constants.STAGE_HEIGHT / 2 - 50;
			addChild(blockSmallImage);
			
			var blockSmall:Body = new Body(BodyType.STATIC, new Vec2(blockSmallImage.x, blockSmallImage.y));
		//	blockSmall.userData.graphic = blockSmallImage;
			blockSmall.shapes.add(new Polygon(Polygon.rect(0, 0, blockSmallImage.width, blockSmallImage.height)));
			blockSmall.space = space;
			
			var blockBigImage:Image = new Image(Root.assets.getTexture("game_block_big"));
			blockBigImage.x = Constants.STAGE_WIDTH / 2 + 50;
			blockBigImage.y = Constants.STAGE_HEIGHT / 2 + 200;
			addChild(blockBigImage);
			
			var blockBig:Body = new Body(BodyType.STATIC, new Vec2(blockBigImage.x, blockBigImage.y));
			//	blockBig.userData.graphic = blockBigImage;
			blockBig.shapes.add(new Polygon(Polygon.rect(0, 0, blockBigImage.width, blockBigImage.height)));
			blockBig.space = space;
			
			var handleImage:Image = new Image(Root.assets.getTexture("game_handle"));
			handleImage.x = Constants.STAGE_WIDTH * 0.5;
			handleImage.y = Constants.STAGE_HEIGHT * 0.7;
			handleImage.pivotX = handleImage.width / 2;
			handleImage.pivotY = handleImage.height / 2;
			addChild(handleImage);
			
			handle = new Body(BodyType.KINEMATIC, new Vec2(handleImage.x, handleImage.y));
			handle.userData.graphic = handleImage;
			handle.shapes.add(new Circle(handleImage.width / 2, null, new Material(0.1)));
			handle.space = space;
			
			addBall();
			
			addEventListener(TouchEvent.TOUCH, touchHandler);
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
			var ballImageName:String =  Math.random() < .5 ? "game_hagisan" : "game_ball";
			var ballImage:Image = new Image(Root.assets.getTexture(ballImageName));
			ballImage.pivotX = ballImage.width / 2;
			ballImage.pivotY = ballImage.height / 2;
			addChild(ballImage);
			ballImage.touchable = true;
			ballImage.addEventListener(TouchEvent.TOUCH, ball_touchHander);
			
			var ball:Body = new Body(BodyType.DYNAMIC, new Vec2(Math.random()*(Constants.STAGE_WIDTH - ballImage.width - 20) + 10 + ballImage.width / 2, 10 + ballImage.height / 2));
			ball.shapes.add(new Circle(ballImage.width / 2, null, new Material(0.7)));
			ball.space = space;
			ball.userData.graphic = ballImage;
		}
		
		private function updateGraphics(b:Body):void
		{
		//	trace(b.position.x, b.position.y);
			
			b.userData.graphic.x = b.position.x;
			b.userData.graphic.y = b.position.y;
			b.userData.graphic.rotation = b.rotation;
		}
		
        private function ball_touchHander(event:TouchEvent):void
        {
            if (event.getTouch(event.currentTarget as DisplayObject, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
            //    Starling.juggler.removeTweens(mBird);
                dispatchEventWith(GAME_OVER, true, 100);
            }
        }
		
		private function touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
			if (!touch)
				return;
				
			if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED)
			{
				handle.position.x = touch.globalX;
				handle.position.y = touch.globalY;
				updateGraphics(handle);
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