package pl.asria.tools.math 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author kontakt@trzeci.eu - Piotr Paczkowski
	 * 
	 * Class with math operation on Line with form: Ax+By+C=0
	 */
	public class MathLine 
	{
		public var A:Number = 0;
		public var B:Number = 0;
		public var C:Number = 0;
		
		public function MathLine(A:Number = 0, B:Number=0, C:Number=0) 
		{
			this.C = C;
			this.B = B;
			this.A = A;
		}
		
		public function moveToPoint(a:Point):Boolean
		{
			if (!isValid()) return false
			C = -(A * a.x + B * a.y);
			return true;
		}
		
		public function isValid():Boolean
		{
			return Math.pow(A,2) + Math.pow(B,2) > 0;
		}
		
		public function isValidNodmalForm():Boolean
		{
			return B != 0;
		}
		
		public function get normalformA():Number
		{
			if (!isValidNodmalForm())
				return Infinity;
			return -A / B;
		}
		
		public function getPerpendicular(crossingPoint:Point):MathLine
		{
			if (!isValid()) return null;

			if (!crossingPoint)
				crossingPoint = new Point();
			if (!A)
				return new MathLine(1, 0, -crossingPoint.x);
			if (!B)
				return new MathLine(0, 1, -crossingPoint.y);
			//return new MathLine(B/A,1,-crossingPoint.y + crossingPoint.x*B/A)
			return new MathLine(-B/A,1,-crossingPoint.y + crossingPoint.x*B/A)
		}
		
		public static function areParallel(k:MathLine, l:MathLine):Boolean
		{
			return k.A * l.B - l.A * k.B == 0;
		}
		
		public function isParallel(l:MathLine):Boolean
		{
			return A * l.B - l.A * B == 0;
			
		}
		
		/**
		 * 
		 * @param	k
		 * @param	l
		 * @return -1 if lines are not parallel
		 */
		public static function distancBetween(k:MathLine, l:MathLine):Number
		{
			if (!areParallel(k, l)) return -1;
			return Math.abs(k.C - l.C)/Math.sqrt(Math.pow(k.A, 2)+Math.pow(l.A, 2));
		}
		public function distanceToLine(l:MathLine):Number
		{
			if (!isParallel(l)) return -1;
			return Math.abs(C - l.C)/Math.sqrt(Math.pow(A, 2)+Math.pow(l.A, 2));
		}
		
		public static function arePerpendicular(k:MathLine, l:MathLine):Boolean
		{
			return l.A * k.A + l.B * k.B == 0;
		}
		public function isPerpendicular(l:MathLine):Boolean
		{
			return l.A * A + l.B * B == 0;
		}
		
		public static function getOverPoints(a:Point, b:Point):MathLine
		{
			return new MathLine(b.y-a.y, a.x-b.x, a.y*b.x-a.x*b.y);
		}
		
		static public function intersectionPoint(k:MathLine, l:MathLine):Point 
		{
			var y:Number = (l.A * k.C - k.A * l.C) / (k.A * l.B - l.A * k.B);
			var x:Number;
			if(l.A !=0)
				x = ( -l.B * y - l.C) / l.A;
			else
				x = ( -k.B * y - k.C) / k.A;
				
			return new Point(x,y);
		}
		
		public function distanceToPoint(a:Point):Number
		{
			return Math.abs(A*a.x + B*a.y +C)/Math.sqrt(Math.pow(A, 2)+Math.pow(A, 2));
		}
		
		public function angleTo(l:MathLine):Number
		{
			return (A * l.B -l.A * B) / (A * l.A + B * l.B);
		}
		
		/**
		 * Calculate total progress between points on this same line 
		 * @param	start
		 * @param	end
		 * @param	crossingPoint
		 * @return
		 */
		public function progressBetween(start:Point, end:Point, crossingPoint:Point):Number 
		{
			if (start.x == end.x)
			{
				if (crossingPoint.y > end.y && end.y >= start.y) return 1;
				if (crossingPoint.y < end.y && end.y <= start.y) return 1;
				if (crossingPoint.y < start.y && start.y <= end.y) return 0;
				if (crossingPoint.y > start.y && start.y >= end.y) return 0;
			}
			else
			{
				if (crossingPoint.x > end.x && end.x >= start.x) return 1;
				if (crossingPoint.x < end.x && end.x <= start.x) return 1;
				if (crossingPoint.x < start.x && start.x <= end.x) return 0;
				if (crossingPoint.x > start.x && start.x >= end.x) return 0;
			}
			return Point.distance(start, crossingPoint)/Point.distance(start, end); // crossingpoint above start point
		}
		
		public function distanceToCircle(center:Point, radious:Number):Number
		{
			return distanceToPoint(center)-radious;
		}
		/*public function getNeighboursAround(point:Point, radius:Number):Array
		{
			if (!B)
				return [new Point(point.x, point.y + radius), new Point(point.x, point.y - radius)];
			if (!A)
				return [new Point(point.x + radius, point.y ), new Point(point.x - radius, point.y)];
				
			var _x:Number;
			var _y:Number;
			
		}*/
		
		public function toString():String
		{
			return "[MathLine]: A = " + A + ", B = " + B + ", C = " + C + ", A*=" + normalformA * 180/Math.PI;
		}
	}

}