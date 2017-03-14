Module Module1

    Sub Main()

        Dim totalsales As Double = 0
        Dim totaldollars As Double = 0


        Dim name As String

        Do
            name = getname()

            If name = "Eugene" Then

                Exit Do

            End If



            Dim Code = getcode()

            Dim sales = getsales()


            totalsales += sales

            Dim dollars As Double

            Select Case Code

                Case 1

                    dollars = 0.01 * sales + 1000


                Case 2

                    dollars = 0.03 * sales


                Case 3

                    dollars = 0.04 * sales + 500


                Case Else

                    dollars = 0.02 * sales + 200




            End Select

            totaldollars += dollars

            print(name, sales, Code, dollars)



        Loop While True

        Console.WriteLine("Total Comission: $" & totaldollars & vbNewLine & "Total Sales: $" & totalsales)




    End Sub

    Sub print(ByVal name As String, ByVal sales As Double, ByVal code As Integer, ByVal dollars As Double)

        Console.WriteLine("Salesperson Name: " & name & vbNewLine & "Salesperson Code: " & code & vbNewLine & "Salesperson Monthly Sales: $" & sales & vbNewLine & "Salesperson Commission Dollars: $" & dollars)

    End Sub

    Function getname()
        Console.Write("Enter Name: ")
        Return Console.ReadLine()



    End Function

    Function getsales()
        Console.Write("Enter Sales: ")
        Return Console.ReadLine()




    End Function

    Function getcode()
        Console.Write("Enter Code: ")
        Return Console.ReadLine()




    End Function




End Module