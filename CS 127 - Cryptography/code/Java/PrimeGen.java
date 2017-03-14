import java.math.BigInteger;
import java.util.Random;

public class PrimeGen
{
    private final Random SEED = new Random();
    private final int DEFAULT_N_BITS = 64;
    private final int DEFAULT_KEY_SPACE = 256;

    private int nbits = DEFAULT_N_BITS;
    private BigInteger p;
    private BigInteger n;
    
    public BigInteger getPrime()
    {
        return generatePrime();
    }
    public BigInteger getPrime(int size)
    {
        nbits = size;
        return generatePrime();
    }
    public boolean testPrime(BigInteger a)
    {
        return primeTestPass(a);
    }
    private BigInteger generatePrime() {
        do {
            p = new BigInteger(nbits, SEED);
            if (p.mod(BigInteger.valueOf(2)).equals(BigInteger.ZERO)) continue;
            if (p.mod(BigInteger.valueOf(3)).equals(BigInteger.ZERO)) continue;
            if (p.mod(BigInteger.valueOf(5)).equals(BigInteger.ZERO)) continue;
            if (p.mod(BigInteger.valueOf(7)).equals(BigInteger.ZERO)) continue;
        } while (!primeTest()); 
        return p;
    }
    private boolean primeTest() {
        for (int repeat = 0; repeat < 20; repeat++) {
            BigInteger a;
            do a = new BigInteger(nbits, SEED);
            while (a.equals(BigInteger.ZERO));
            if (!primeTestPass(a)) return false;
        }
        return true;
    }
    private boolean primeTestPass(BigInteger a) {
        BigInteger n = p;
        BigInteger n_minus_1 = n.subtract(BigInteger.ONE);
        BigInteger d = n_minus_1;
        int s = d.getLowestSetBit();
        d = d.shiftRight(s);
        BigInteger aToPow = a.modPow(d, n);
        
        if (aToPow.equals(BigInteger.ONE)) return true;
        for (int i = 0; i < s - 1; i++) {
            if (aToPow.equals(n_minus_1)) return true;
            aToPow = aToPow.multiply(aToPow).mod(n);
        }
        if (aToPow.equals(n_minus_1)) return true;
        return false;
    }


}
