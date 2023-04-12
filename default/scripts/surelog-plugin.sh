sed -i 's,/yosyshq/share,../../yosys/yosyshq/share,g' yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/include,../../yosys/yosyshq/include,g' yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/lib,../../yosys/yosyshq/lib,g' yosys/yosyshq/bin/yosys-config
mkdir -p ${OUTPUT_DIR}/yosyshq/share/yosys/plugins
mkdir -p ${BUILD_DIR}/surelog/dev/lib/uhdm
mkdir -p ${BUILD_DIR}/surelog/dev/lib/surelog
cd surelog-plugin
sed -i 's,DATA_DIR = \$(DESTDIR)\$(shell \$(YOSYS_CONFIG) --datdir),DATA_DIR = ${OUTPUT_DIR}/yosyshq/share/yosys,g' Makefile_plugin.common
sed -i 's,PLUGINS_DIR = \$(DATA_DIR)/plugins,PLUGINS_DIR = ${OUTPUT_DIR}/yosyshq/share/yosys/plugins,g' Makefile_plugin.common
if [ ${ARCH_BASE} == 'darwin' ] ; then
    sed -i 's,-Wl\,--whole-archive,,g' systemverilog-plugin/Makefile
    sed -i 's,-Wl\,--no-whole-archive,,g' systemverilog-plugin/Makefile
    sed -i 's,-lrt,,g' systemverilog-plugin/Makefile
    export MACOSX_DEPLOYMENT_TARGET=10.15
fi
if [ ${ARCH_BASE} == 'windows' ] ; then
    sed -i 's,-lutil,,g' systemverilog-plugin/Makefile
    sed -i 's,-lrt,,g' systemverilog-plugin/Makefile
    sed -i 's,-lantlr4-runtime,-lantlr4-runtime-static,g' systemverilog-plugin/Makefile
    sed -i 's,__MINGW32__,__IGNORE_MINGW__,g' ${BUILD_DIR}/surelog/dev/include/uhdm/vpi_user.h 
    sed -i 's,__MINGW32__,__IGNORE_MINGW__,g' ${BUILD_DIR}/surelog/dev/include/uhdm/vhpi_user.h 
     
    sed -i 's,yosys.h",yosys.h"\n#ifdef _WIN32\n#undef interface\n#undef ERROR\n#endif\n,g' systemverilog-plugin/uhdmastreport.h
    sed -i 's,yosys.h",yosys.h"\n#ifdef _WIN32\n#undef interface\n#undef ERROR\n#endif\n,g' systemverilog-plugin/uhdmcommonfrontend.h     
    sed -i 's,\, 0777,,g' systemverilog-plugin/uhdmastreport.cc
fi
make YOSYS_PATH=${BUILD_DIR}/yosys/yosyshq/ DESTDIR=${OUTPUT_DIR} -j${NPROC} PLUGIN_LIST="systemverilog" UHDM_INSTALL_DIR=${BUILD_DIR}/surelog/dev install