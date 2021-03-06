
tup.include('build.lua')

--FLAGS += '-Werror'
-- C-specific flags
FLAGS += '-D__weak="__attribute__((weak))"'
FLAGS += '-D__packed="__attribute__((__packed__))"'
FLAGS += '-DDEBUG=1'
FLAGS += '-DCPU_MIMXRT1052DVL6B'
FLAGS += '-DUSB_STACK_BM'
FLAGS += '-D__FPU_PRESENT=1'
FLAGS += '-DARM_MATH_CM4'
FLAGS += '-DARM_MATH_MATRIX_CHECK'
FLAGS += '-DARM_MATH_ROUNDING'

FLAGS += '-mthumb'
FLAGS += '-mcpu=cortex-m7'
FLAGS += '-mfpu=fpv4-sp-d16'
FLAGS += '-mfloat-abi=hard'
FLAGS += { '-Wall', '-Wfloat-conversion', '-fdata-sections', '-ffunction-sections'}

-- debug build
FLAGS += '-g -gdwarf-2'

boarddir = 'devices/MIMXRT1052/gcc'

-- linker flags
LDFLAGS += '-T'..boarddir..'/MIMXRT1052xxxxx_ram.ld'
--LDFLAGS += '-T'..boarddir..'/MIMXRT1052xxxxx_flexspi_nor.ld'
-- LDFLAGS += '-L'..boarddir..'/CMSIS/Lib' -- lib dir
-- LDFLAGS += '-lc -lm -lnosys -larm_cortexM4lf_math' -- libs
LDFLAGS += '-mthumb -mcpu=cortex-m7 -mfpu=fpv4-sp-d16 -mfloat-abi=hard  -specs=nosys.specs -specs=nano.specs -u _printf_float -u _scanf_float -Wl,--cref -Wl,--gc-sections'
LDFLAGS += '-Wl,--undefined=uxTopUsedPriority'


-- common flags for ASM, C and C++
OPT += '-O3'
OPT += '-ffast-math -fno-finite-math-only'
tup.append_table(FLAGS, OPT)
tup.append_table(LDFLAGS, OPT)

toolchain = GCCToolchain('arm-none-eabi-', 'build', FLAGS, LDFLAGS)

-- Load list of source files Makefile that was autogenerated by CubeMX
--[[
vars = parse_makefile_vars(boarddir..'/Makefile')
all_stm_sources = (vars['C_SOURCES'] or '')..' '..(vars['CPP_SOURCES'] or '')..' '..(vars['ASM_SOURCES'] or '')
for src in string.gmatch(all_stm_sources, "%S+") do
    stm_sources += boarddir..'/'..src
end
for src in string.gmatch(vars['C_INCLUDES'] or '', "%S+") do
    stm_includes += boarddir..'/'..string.sub(src, 3, -1) -- remove "-I" from each include path
end
]]--

build{
    name='IMXRT1052',
    toolchains={toolchain},
    packages={},
    sources={
        'app/usb_device_cdc_acm.c',
        'app/usb_device_ch9.c',
        'app/usb_device_descriptor.c',
        'app/virtual_com.c',
        'app/usb_device_class.c',
        'board/board.c',
        'board/clock_config.c',
        'board/peripherals.c',
        'board/pin_mux.c',
        'devices/MIMXRT1052/gcc/startup_MIMXRT1052.s',
        'devices/MIMXRT1052/system_MIMXRT1052.c',
        'devices/MIMXRT1052/drivers/fsl_cache.c',
        'devices/MIMXRT1052/drivers/fsl_common.c',
        'devices/MIMXRT1052/drivers/fsl_flexio.c',
        'devices/MIMXRT1052/drivers/fsl_gpio.c',
        'devices/MIMXRT1052/drivers/fsl_pit.c',
        'devices/MIMXRT1052/drivers/fsl_lpuart.c',
        'devices/MIMXRT1052/drivers/fsl_clock.c',
        'devices/MIMXRT1052/utilities/fsl_debug_console.c',
        'devices/MIMXRT1052/utilities/log/fsl_log.c',
        'devices/MIMXRT1052/utilities/io/fsl_io.c',
        'devices/MIMXRT1052/utilities/str/fsl_str.c',
        'middleware/usb/device/usb_device_ehci.c',
        'middleware/usb/device/usb_device_dci.c',
        'middleware/usb/osa/usb_osa_bm.c',
        'middleware/usb/phy/usb_phy.c'
    },
    includes={
        'app',
        'board',
        'CMSIS/Include',
        'devices/MIMXRT1052',
        'devices/MIMXRT1052/cmsis_drivers',
        'devices/MIMXRT1052/xip',
        'devices/MIMXRT1052/drivers',
        'devices/MIMXRT1052/utilities',
        'devices/MIMXRT1052/utilities/str',
        'devices/MIMXRT1052/utilities/log',
        'devices/MIMXRT1052/utilities/io',
        'middleware/usb/include',
        'middleware/usb/device',
        'middleware/usb/osa',
        'middleware/usb/phy'
    }
}
