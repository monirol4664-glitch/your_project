namespace MathToolsApp.Services;

public class StatisticsEngine
{
    public double Mean(double[] data) => data.Average();
    
    public double Median(double[] data)
    {
        var sorted = data.OrderBy(x => x).ToArray();
        int n = sorted.Length;
        
        if (n % 2 == 0)
            return (sorted[n / 2 - 1] + sorted[n / 2]) / 2;
        return sorted[n / 2];
    }
    
    public double Mode(double[] data)
    {
        var groups = data.GroupBy(x => x);
        int maxCount = groups.Max(g => g.Count());
        var modes = groups.Where(g => g.Count() == maxCount).Select(g => g.Key);
        return modes.First(); // Returns first mode if multiple
    }
    
    public double StandardDeviation(double[] data)
    {
        double mean = Mean(data);
        double sumSquaredDiff = data.Sum(x => Math.Pow(x - mean, 2));
        return Math.Sqrt(sumSquaredDiff / data.Length);
    }
    
    public double Variance(double[] data) => Math.Pow(StandardDeviation(data), 2);
    
    public (double slope, double intercept, double correlation) LinearRegression(double[] x, double[] y)
    {
        if (x.Length != y.Length || x.Length < 2)
            throw new ArgumentException("Arrays must have same length >= 2");
        
        int n = x.Length;
        double sumX = x.Sum();
        double sumY = y.Sum();
        double sumXY = x.Zip(y, (xi, yi) => xi * yi).Sum();
        double sumX2 = x.Sum(xi => xi * xi);
        
        double slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
        double intercept = (sumY - slope * sumX) / n;
        
        // Pearson correlation coefficient
        double sumY2 = y.Sum(yi => yi * yi);
        double correlation = (n * sumXY - sumX * sumY) / 
            Math.Sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
        
        return (slope, intercept, correlation);
    }
    
    public double[] GenerateSequence(double start, double end, int count)
    {
        double[] result = new double[count];
        double step = (end - start) / (count - 1);
        
        for (int i = 0; i < count; i++)
            result[i] = start + i * step;
        
        return result;
    }
}