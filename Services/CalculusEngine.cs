namespace MathToolsApp.Services;

public class CalculusEngine
{
    // Numerical derivative using central difference
    public double Derivative(Func<double, double> f, double x, double h = 1e-6)
    {
        return (f(x + h) - f(x - h)) / (2 * h);
    }

    // Numerical integral using Simpson's rule
    public double Integrate(Func<double, double> f, double a, double b, int n = 1000)
    {
        if (n % 2 != 0) n++; // Simpson's rule requires even number of intervals
        
        double h = (b - a) / n;
        double sum = f(a) + f(b);
        
        for (int i = 1; i < n; i++)
        {
            double x = a + i * h;
            sum += (i % 2 == 0) ? 2 * f(x) : 4 * f(x);
        }
        
        return (h / 3) * sum;
    }

    // Find root using Newton-Raphson method
    public double FindRoot(Func<double, double> f, Func<double, double> fPrime, double initialGuess, double tolerance = 1e-6, int maxIterations = 100)
    {
        double x = initialGuess;
        
        for (int i = 0; i < maxIterations; i++)
        {
            double fx = f(x);
            if (Math.Abs(fx) < tolerance)
                return x;
            
            double fpx = fPrime(x);
            if (Math.Abs(fpx) < tolerance)
                throw new Exception("Derivative too small, method failed");
            
            x = x - fx / fpx;
        }
        
        throw new Exception("Maximum iterations reached");
    }

    // Limit calculator
    public double Limit(Func<double, double> f, double x0, double direction = 0) // direction: -1=left, 0=both, 1=right
    {
        double h = 1e-8;
        
        if (direction <= 0) // left limit
        {
            double left = f(x0 - h);
            if (direction == 0) // both sides
            {
                double right = f(x0 + h);
                if (Math.Abs(left - right) < 1e-6)
                    return left;
                throw new Exception("Limit does not exist (left ≠ right)");
            }
            return left;
        }
        
        return f(x0 + h); // right limit
    }
}