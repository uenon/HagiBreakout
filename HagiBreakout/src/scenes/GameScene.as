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
		
		private function init(event:Event):void
		{
			
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
			
			if (Math.random() < 0.03)
				addBall();
			
			space.liveBodies.foreach(updateGraphics);
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