package
{
	import starling.display.Sprite;
	
	public class ClipSprite extends Sprite
	{
		public var originalWidth:Number;
		public var originalHeight:Number;
		
		
		public function ClipSprite(originalWidth:Number, originalHeight:Number = 0)
		{
			super();
			
			this.originalWidth = originalWidth;
			this.originalHeight = originalHeight;
		}
	}
}