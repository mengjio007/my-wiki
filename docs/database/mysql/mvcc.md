# MVCC 实现

## 概述

MVCC（Multi-Version Concurrency Control，多版本并发控制）是 InnoDB 实现高并发读写的核心机制。

## 核心组件

- **隐藏列**：DB_TRX_ID、DB_ROLL_PTR、DB_ROW_ID
- **Undo Log**：版本链
- **Read View**：可见性判断
