package scenes
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class SettingsScene extends Screen
	{
		public static const CLOSE_SETTINGS:String = "closeSettings";
		
		public function SettingsScene()
		{
			super();
		}
		
		private var _list:List;
		private var _closeButton:Button;
		private var _header:Header;
		private var _statsToggle:ToggleSwitch;
		private var _frameRatePicker:PickerList;
		
		override protected function initialize():void
		{
			// ScreenNavigatorを使えばScreenのサイズは自動的に設定されるけど、ここでは明示的に。
			setSize(Starling.current.stage.width, Starling.current.stage.height);
			
			// これを設定するとAndroidのハードキーをハンドリングできるよう（Screenの機能）
			backButtonHandler = closeButton_triggeredHandler;
			menuButtonHandler = closeButton_triggeredHandler;
			
			this.addChild(Root.theme.feathersBackground);
			
			this._statsToggle = new ToggleSwitch();
			this._statsToggle.isSelected = Root.settings.statsVisible;
			this._statsToggle.addEventListener(Event.CHANGE, statsToggle_changeHandler);
			
			this._frameRatePicker = new PickerList();
			this._frameRatePicker.typicalItem = Button.HORIZONTAL_ALIGN_CENTER;
			this._frameRatePicker.dataProvider = new ListCollection(new <Number>[30, 60]);
			this._frameRatePicker.listProperties.typicalItem = Button.HORIZONTAL_ALIGN_CENTER;
			this._frameRatePicker.selectedItem = Root.settings.frameRate;
			this._frameRatePicker.addEventListener(Event.CHANGE, frameRatePicker_changeHandler);
			
			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
				[
					{ label: "stats", accessory: this._statsToggle },
					{ label: "fps", accessory: this._frameRatePicker },
				]);
			this.addChild(this._list);
			
			this._closeButton = new Button();
			this._closeButton.label = "閉じる";
			this._closeButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			
			this._header = new Header();
			this._header.title = "設定";
			this.addChild(this._header);
			this._header.rightItems = new <DisplayObject>
				[
					this._closeButton
				];

		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();
			
			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
		}
		
		override public function dispose():void
		{
			// feathersBackgroundは再利用するのでdispose()しない
			this.removeChild(Root.theme.feathersBackground);
			super.dispose();
		}
		
		private function closeButton_triggeredHandler():void
		{
			dispatchEventWith(CLOSE_SETTINGS, true, 100);
		}
		
		private function statsToggle_changeHandler():void
		{
			Root.settings.statsVisible = this._statsToggle.isSelected;
			Starling.current.showStats = Root.settings.statsVisible;
		}
		
		private function frameRatePicker_changeHandler():void
		{
			Root.settings.frameRate = this._frameRatePicker.selectedItem as Number;
			Starling.current.nativeStage.frameRate = Root.settings.frameRate;
		}
	}
}