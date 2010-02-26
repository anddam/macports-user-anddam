oct['arpack'].deps = {"arpack"}
oct['bim'].deps = {"octave-fpl", "octave-msh"}
oct['communications'].deps = {"octave-signal"}
oct['financial'].deps = {"octave-time"}
oct['ga'].deps = {"octave-miscellaneous"}
oct['graceplot'].deps = {"octave-io"}
oct['jhandles'].deps = {"octave-java"}
oct['msh'].deps = {"octave-splines"}
oct['optim'].deps = {"octave-miscellaneous"}
oct['tsa'].deps = {"octave-nan"}
oct['octcdf'].deps = {"netcdf"}
oct['video'].deps = {"ffmpeg"}

--disabled
--[[oct['arpack'].disabled = true
oct['symbolic'].disabled = true
oct['communications'].disabled = true
oct['database'].disabled = true
oct['fixed'].disabled = true
oct['ftp'].disabled = true
oct['jhandles'].disabled = true
oct['octgpr'].disabled = true
oct['odepkg'].disabled = true
oct['secs2d'].disabled = true
oct['video'].disabled = true
oct['xraylib'].disabled = true

]]