# ic_template
A template project for beginning new digital ic work

Author：Brimonzzy

Email：zzybr@qq.com

</br>

TODO：

- [ ] 重写gitignore文件
- [ ] 跑通Spyglass语法检查脚本
- [ ] 跑通Vivado综合以及实现脚本
- [ ] 完善DC脚本参数化（parameter the search path and library name）
- [ ] DC脚本可以参数化选择多种PDK文件
- [ ] 编写Xcelium仿真脚本
- [ ] 编写Verilator仿真脚本和tb模板

</br>

</br>

src/rtl下有一个mult_16(wallace tree)和cla_32作为例程

</br>

文件结构：


```
.
├── README.md
├── software # 存放用到的软件算法代码
├── docs # spec、整体架构、接口时序、测试用例说明、测试结果波形、主要模块架构、ASIC或者FPGA综合结果
├── rtl
|   ├── src
|   ├── sim
|   |   ├── lib # 存放一些仿真库，例如 sim_models
|   |   ├── tb_src # testbench
|   |   ├── vcs
│   │   │   ├── vcs.mk
|   |   |   └── Makefile
|   |   ├── xcelium
│   │   │   ├── xcelium.mk
|   |   |   └── Makefile
|   |   └── verilator
|   |       └── Makefile
|   ├── lint
|   |   └── spyglass
|   └── syn
|       ├── syn_asic
|       |   ├── db # 存放PDK
|       |   ├── (syn # 生成的报告)
|       |   └── scripts # ASIC综合脚本、约束文件
|       └── syn_fpga
|           └── scripts # FPGA综合脚本
├── scripts
└── (backup # 生成的备份)

```

</br>

</br>

备份工程文件夹：

```shell
cd scripts
./backup.sh
```

</br>

清空工程文件夹下所有临时文件：

```shell
cd scripts
./clean.sh
```

</br>

VCS仿真：

```shell
cd rtl/sim/vcs
# VCS编译
make simv MODEL_NAME=<tb_name>
# VCS编译以及运行
make run MODEL_NAME=<tb_name>
# VCS编译(debug模式)
make debug MODEL_NAME=<tb_name>
# VCS编译以及运行(debug模式)
make rundebug MODEL_NAME=<tb_name>
# 打开波形文件
make wave MODEL_NAME=<tb_name>
# 清楚中间文件
make clean
```

</br>

DC综合：

```shell
cd syn/syn_asic
make syn
```

约束文件在`scripts/sdc.tcl`中修改


