# AI 개발 및 서버 환경 가이드

본 서버 환경은 **"평소 빠른 개발은 `uv` + `tmux`"**, **"복잡한 외부 프로젝트 및 CUDA 격리는 `drun` (도커 컨테이너)"** 방식으로 이원화되어 있습니다.

---

## 1. 일상 개발 워크플로우 (Host 환경)

평소 본인의 프로젝트를 가볍고 빠르게 개발할 때 사용합니다.

### 1) 3분할 GPU 모니터링 세션 실행
```bash
tg              # 기본 세션(main)으로 3분할 실행 (gpustat 자동 켜짐)
tg my_project   # 특정 세션 이름으로 실행
```

### 2) `uv` 기반 가상환경 관리
```bash
uv venv                       # .venv 가상환경 초고속 생성 (1초)
source .venv/bin/activate     # 가상환경 활성화
uv pip install torch torchvision  # 초고속 패키지 설치
```

---

## 2. 격리된 AI 컨테이너 워크플로우 (`drun`)

Conda(`environment.yml`)를 요구하는 외부 오픈소스나 특정 CUDA 버전이 필요한 프로젝트를 돌릴 때 사용합니다.

### 1) 컨테이너 실행 명령어 (`drun`)
```bash
# 1. 기본 실행 (CUDA 12.4 + Python 3.11 + Miniforge Conda + uv + dotfiles)
drun

# 2. CUDA 버전 지정 실행 (예: CUDA 11.8)
drun 11.8

# 3. CUDA + Python 버전 모두 지정 (예: CUDA 11.8 + Python 3.10)
drun 11.8 3.10

# 4. 특정 GPU 지정 (예: 0번, 1번 GPU만 사용)
drun -g "device=0,1" 12.4
```

### 2) 컨테이너 내부 기능
* **Conda (Miniforge)**: 
  * 컨테이너 진입 시 `(base)` 환경 자동 활성화
  * `conda create -n myenv python=3.10` / `conda env create -f environment.yml` 바로 사용 가능
* **`uv` & `uvx`**: 
  * 컨테이너 내부에서도 `uv` 명령어 즉시 사용 가능
* **Dotfiles 자동 연동**:
  * Zsh 테마, 별칭(aliases), 3분할 tmux(`tg`) 등 내 설정 그대로 유지
* **자동 마운트 & 최적화**:
  * 현재 작업 디렉터리가 `/workspace`에 자동 마운트됨
  * PyTorch 멀티프로세싱 OOM 방지(`--ipc=host`) 및 전체 GPU 할당(`--gpus all`)

---

## 3. 유용한 단축어(Alias) 모음

| 단축어 | 설명 |
| :--- | :--- |
| `tg` | GPU 상단 모니터링 + 3분할 tmux 세션 자동 실행/접속 |
| `drun` | AI 개발용 GPU 컨테이너 즉시 실행 (CUDA/Python 지정 가능) |
| `gs` / `ga` / `gc` / `gp` / `gd` | Git 단축어 (`status`, `add`, `commit`, `push`, `diff`) |
| `sq` / `sqyh` | Slurm 전체 작업 조회 / 내 작업(`shu914`) 필터링 조회 |
| `nvitop` | 실시간 인터랙티브 GPU 모니터링 도구 실행 |
