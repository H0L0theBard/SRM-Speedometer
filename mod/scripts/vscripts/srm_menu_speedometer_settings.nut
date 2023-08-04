global function SRM_InitSpeedometerSettingsMenu

void function SRM_InitSpeedometerSettingsMenu()
{
	ModSettings_AddModTitle("SRM Speedometer")

	ModSettings_AddModCategory( "Function" )

	ModSettings_AddDropDown( "srm_speedometer_unit", "Unit", [ "km/h", "m/s", "mph","u"], true )
	ModSettings_AddDropDown( "srm_speedometer_axismode", "Axis", [ "XY","Z"], true )

	// position
	ModSettings_AddModCategory( "Position" )

	ModSettings_AddSliderSetting( "srm_speedometer_position_x", "Position X", 0.0,1.0,0.6, true)
	ModSettings_AddSliderSetting( "srm_speedometer_position_y", "Position Y", 0.0,1.0,0.48, true)

	// color when moving slowly
	ModSettings_AddModCategory( "Colors" )
	AddModSettingsRGBColorPicker( "srm_speedometer_color_slow", "Color of Speedometer when slow" )

	// color when moving fast
	AddModSettingsRGBColorPicker( "srm_speedometer_color_fast", "Color of Speedometer when fast" )

	// Alpha
	ModSettings_AddSliderSetting( "srm_speedometer_alpha", "Transparency", 0, 1, 1, true )

}

void function AddModSettingsRGBColorPicker( string conVar, string buttonLabel, bool liveUpdate = false )
{
	ModSettings_AddButton( buttonLabel,
		void function() : ( conVar )
		{
			thread void function() : ( conVar )
			{
				EndSignal( uiGlobal.signalDummy, "ColorPickerSelected" )
				OpenColorPickerDialog( conVar, false, false, false )

				OnThreadEnd( void function()
					{
						CloseSubmenu()
					}
				)

				while( true )
				{
					table response = WaitSignal( uiGlobal.signalDummy, "ColorPickerLiveUpdate", "ColorPickerDialogReset" )

					if( response.signal == "ColorPickerDialogReset" )
					{
						SetConVarToDefault( conVar )
						return
					}

					vector ornull rgb = expect vector ornull( response[ "color" ] )
					if( rgb == null )
						continue
					expect vector( rgb )

					SetConVarString( conVar, format( "%.1f %.1f %1.f", rgb.x / 255, rgb.y / 255, rgb.z / 255 ) )
				}
			}()
		}, 3
	)
}