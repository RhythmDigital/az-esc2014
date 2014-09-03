package com.astrazeneca
{
	import com.astrazeneca.starling.StarlingQuadButton;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class Menu extends Sprite
	{
		private var menuFlat:Image;
		private var menuItems:Array;
		private var buttonContainer:Sprite;

		private var menuOver:ClipSprite;
		
		
		public function Menu()
		{
			super();
			
			var loader:LoaderMax = new LoaderMax({ onComplete:onInitialLoad });
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/menu-out.png', {name:'menu-out'}));
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/menu-over.png', {name:'menu-over'}));
			loader.load();
			
		}
		
		private function onInitialLoad(e:LoaderEvent):void
		{
			var menuFlat:Image = StarlingUtils.imageFromBitmap(LoaderMax.getContent('menu-out').rawContent);
			
			var menuOverImage:Image = StarlingUtils.imageFromBitmap(LoaderMax.getContent('menu-over').rawContent);
			menuOver = new ClipSprite(menuOverImage.width);
			menuOver.clipRect = new Rectangle();
			menuOver.addChild(menuOverImage);
			
			y = 1920 - menuFlat.height;
			addChild(menuFlat);
			addChild(menuOver);
			
			createButtons();
		}
		
		private function createButtons():void
		{
			
			menuItems = [
					{id:"meetEric", rect:new Rectangle(194,45,126,145)}
				,	{id:"sustainedEfficacy", rect:new Rectangle(319,45,126,145)}
				,	{id:"superiorBasal", rect:new Rectangle(444,45,126,145)}
				,	{id:"weeklyDosing", rect:new Rectangle(570,45,126,145)}
				,	{id:"safetyTolerability", rect:new Rectangle(695,45,126,145)}
				,	{id:"busyLives", rect:new Rectangle(821,45,127,145)}
				,	{id:"rfid", rect:new Rectangle(948,45,127,145)}
			]
					
			buttonContainer = new Sprite();
			
			
			
			for(var i:int = 0; i < menuItems.length; ++i)
			{
				var btn:Quad = new StarlingQuadButton(menuItems[i].id, menuItems[i].rect.width, menuItems[i].rect.height, 0xff0000);
				btn.x = menuItems[i].rect.x;
				btn.y = menuItems[i].rect.y;
				menuItems.btn = btn;
				buttonContainer.addChild(btn);
			}
			
			
			addChild(buttonContainer);
		}
		
		private function onButtonTouched(e:Event):void
		{
			trace("Clicked ", e.data.id);
		}
		
		public function highlight(nextScreenID:String):void
		{
			for(var i:int = 0; i < menuItems.length; ++i)
			{
				if(menuItems[i].id == nextScreenID)
				{
					setHoverClipRect(menuItems[i].rect);
				}
			}
		}
		
		private function setHoverClipRect(r:Rectangle):void
		{
			menuOver.clipRect = r;
		}
	}
}