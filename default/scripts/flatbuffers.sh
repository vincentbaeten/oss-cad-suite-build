cd surelog/third_party/flatbuffers
cmake -DCMAKE_BUILD_TYPE=Release
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install