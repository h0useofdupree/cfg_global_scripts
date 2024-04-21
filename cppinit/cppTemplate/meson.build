project('chernoCourse', 'cpp', default_options : ['cpp_std=c++17', 'buildtype=debug', 'optimization=3', 'b_ndebug=if-release'])

inc = include_directories('include')

subdir('src')

executable('main', sources: sources,
       include_directories: inc,
       install: true)

# custom_target('main_asm',
#     output: 'main.s',
#     command: ['g++', '-S', '@INPUT@', '-o', '@OUTPUT@', '-fverbose-asm'],
#     input: 'src/main.cpp',
#     build_by_default: true
# )
