context C1 {
   public C1(double d) {
      R1 = d
   }
   role R1 {
      public void r1Method() {
      }
      public int compare(double amount) { return compareTo(amount) }
   } requires {
      int compareTo(double amount) const;
   }
   public void enact() {
      double d2 = 50.00;
      boolean fiftyLessThan10a = R1 > d2;
      System.out.print("fiftyLessThan10=")
                .println(fiftyLessThan10a)
      int fiftyLessThan10b = R1.compare(d2);
      System.out.print("fiftyLessThan10=")
                .println(fiftyLessThan10b)
   }
}

{
   C1 aContext = new C1(10.00);
   aContext.enact()
}

/* GOLD:
0 warnings, 0 errors.
___________________________________________________________
fiftyLessThan10=false
fiftyLessThan10=-1
*/
