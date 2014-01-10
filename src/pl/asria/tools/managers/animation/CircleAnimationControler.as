package pl.asria.tools.managers.animation 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class CircleAnimationControler extends Sprite
	{
		private var angle:Number;
		private var classDefinition:Class;
		private var contenerRotated:Sprite = new Sprite();
		private var _angle:Number = 0;
		
		public function CircleAnimationControler(angle:Number, classDefinition:Class, pivot:Point) 
		{
			addChild(contenerRotated);
			contenerRotated.x = pivot.x;
			contenerRotated.y = pivot.y;
			
			var _tmp:Sprite = new classDefinition() as Sprite;
			var _matrix:Matrix = new Matrix(1, 0, 0, 1, -pivot.x, -pivot.y);
			contenerRotated.addChild(_tmp);
			_matrix.rotate( -angle*Math.PI / 180);
			_tmp.transform.matrix = _matrix;
			
			_tmp = new classDefinition() as Sprite;
			_matrix = new Matrix(1, 0, 0, 1, -pivot.x, -pivot.y);
			_tmp.transform.matrix = _matrix;
			contenerRotated.addChild(_tmp);
			
			_tmp = new classDefinition() as Sprite;
			_matrix = new Matrix(1, 0, 0, 1, -pivot.x, -pivot.y);
			_matrix.rotate( angle*Math.PI / 180);
			_tmp.transform.matrix = _matrix;
			contenerRotated.addChild(_tmp);
			
			
			this.classDefinition = classDefinition;
			this.angle = angle;
		}
		override public function get rotation():Number 
		{
			return _angle;
		}
		override public function set rotation(value:Number):void 
		{
			//super.rotation = value;
			var direction:int = value < 0 ? -1 : 1;
			value = Math.abs(value);
			value = value % angle;
			value *= direction;
			_angle = value;
			contenerRotated.rotation = value;
		}
		override public function get rotationZ():Number 
		{
			return _angle;
		}
		override public function set rotationZ(value:Number):void 
		{
			//super.rotation = value;
			rotation = value;
		}
		
	}

}