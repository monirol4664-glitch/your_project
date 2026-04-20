namespace MathToolsApp.Services;

public class MatrixService
{
    public double[,] Add(double[,] a, double[,] b)
    {
        if (a.GetLength(0) != b.GetLength(0) || a.GetLength(1) != b.GetLength(1))
            throw new ArgumentException("Matrices must have same dimensions");
        
        int rows = a.GetLength(0);
        int cols = a.GetLength(1);
        double[,] result = new double[rows, cols];
        
        for (int i = 0; i < rows; i++)
            for (int j = 0; j < cols; j++)
                result[i, j] = a[i, j] + b[i, j];
        
        return result;
    }
    
    public double[,] Multiply(double[,] a, double[,] b)
    {
        int rowsA = a.GetLength(0);
        int colsA = a.GetLength(1);
        int rowsB = b.GetLength(0);
        int colsB = b.GetLength(1);
        
        if (colsA != rowsB)
            throw new ArgumentException("Invalid dimensions for multiplication");
        
        double[,] result = new double[rowsA, colsB];
        
        for (int i = 0; i < rowsA; i++)
            for (int j = 0; j < colsB; j++)
                for (int k = 0; k < colsA; k++)
                    result[i, j] += a[i, k] * b[k, j];
        
        return result;
    }
    
    public double Determinant(double[,] matrix)
    {
        int n = matrix.GetLength(0);
        
        if (n == 1) return matrix[0, 0];
        if (n == 2) return matrix[0, 0] * matrix[1, 1] - matrix[0, 1] * matrix[1, 0];
        
        double det = 0;
        for (int i = 0; i < n; i++)
        {
            double[,] subMatrix = GetSubMatrix(matrix, 0, i);
            det += Math.Pow(-1, i) * matrix[0, i] * Determinant(subMatrix);
        }
        
        return det;
    }
    
    private double[,] GetSubMatrix(double[,] matrix, int excludeRow, int excludeCol)
    {
        int n = matrix.GetLength(0);
        double[,] result = new double[n - 1, n - 1];
        int r = 0;
        
        for (int i = 0; i < n; i++)
        {
            if (i == excludeRow) continue;
            int c = 0;
            for (int j = 0; j < n; j++)
            {
                if (j == excludeCol) continue;
                result[r, c] = matrix[i, j];
                c++;
            }
            r++;
        }
        
        return result;
    }
}