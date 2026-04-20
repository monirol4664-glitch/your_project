namespace MathToolsApp.Services;

public class AlgebraSolver
{
    public (double? x1, double? x2, string message) SolveQuadratic(double a, double b, double c)
    {
        if (a == 0) return (null, null, "Not a quadratic equation (a ≠ 0)");
        
        double discriminant = b * b - 4 * a * c;
        
        if (discriminant < 0)
            return (null, null, $"No real solutions (discriminant = {discriminant:F2})");
        
        if (discriminant == 0)
        {
            double x = -b / (2 * a);
            return (x, null, $"One solution: x = {x:F4}");
        }
        
        double x1 = (-b + Math.Sqrt(discriminant)) / (2 * a);
        double x2 = (-b - Math.Sqrt(discriminant)) / (2 * a);
        return (x1, x2, $"x₁ = {x1:F4}\nx₂ = {x2:F4}");
    }
}