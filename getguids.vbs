' Connect to Windows Installer object
Dim installer : Set installer = Wscript.CreateObject("WindowsInstaller.Installer")
' List all installed or advertised products
Dim product, products, info, productList, version
Set products = installer.Products
For Each product In products
info = product & " " & installer.ProductInfo(product, "ProductName")
if productList <> Empty then productList = productList & vbNewLine & info else productList = info
Next
if productList = Empty then productList = "No products installed or advertised"
' Write results to file
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.CreateTextFile("ProductsList.txt", True)
file.WriteLine(productList)
file.Close