        ��  ��                        �� ��     0         <?xml version="1.0" encoding="UTF-8" standalone="yes"?> 

<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0"> 
	<trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">
		<security>
			<requestedPrivileges>
				<requestedExecutionLevel
					level="asInvoker"
					uiAccess="false"
				/>
			</requestedPrivileges>
		</security>
	</trustInfo>

	<compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1"> 
			<application> 
				<!-- This Id value indicates the application supports Windows Vista functionality -->
				<supportedOS Id="{e2011457-1546-43c5-a5fe-008deee3d3f0}" /> 
				<!-- This Id value indicates the application supports Windows 7 functionality -->
				<supportedOS Id="{35138b9a-5d96-4fbd-8e2d-a2440225f93a}" />
			</application> 
	</compatibility>

	<assemblyIdentity 
		version="1.0.0.0" 
		processorArchitecture="X86" 
		name="viathinksoft.test" 
		type="win32" 
	/> 

	<description>ViaThinkSoft Test</description> 

	<dependency>
		<dependentAssembly>
			<assemblyIdentity
				type="win32"
				name="Microsoft.Windows.Common-Controls"
				version="6.0.0.0"
				publicKeyToken="6595b64144ccf1df"
				language="*"
				processorArchitecture="*"
			/>
		</dependentAssembly>
	</dependency>
</assembly>
