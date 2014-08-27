package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	
	import flash.filesystem.File;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	public class Menu extends Sprite
	{
		private var menuFlat:Image;
		
		
		public function Menu()
		{
			super();
			
			var loader:LoaderMax = new LoaderMax({ onComplete:onInitialLoad });
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/test/menu-flat.png', {name:'menu-flat'}));
			loader.load();
		}
		
		private function onInitialLoad(e:LoaderEvent):void
		{
			var menuFlat:Image = StarlingUtils.imageFromBitmap(LoaderMax.getContent('menu-flat').rawContent);
			y = 1920 - menuFlat.height;
			addChild(menuFlat);
		}
	}
}