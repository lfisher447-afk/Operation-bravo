# Operation-Bravo Source Code Base

Operation-Bravo is a modular, high-fidelity Roblox Tactical FPS compilation and security mitigation framework. It integrates procedural asset construction, physics-based movement rendering, server-authoritative coordinate verification, and a multi-layered telemetry anti-cheat engine.

This repository uses a structured **Service-Controller** architecture managed via **Rojo** and integrated with the **Nevermore Framework** (`ServiceBag` system).

---

## 1. System Architecture & Folder Structure

The directory layout enforces a strict segregation of client interfaces, server validation systems, and shared resources:

```
Operation-bravo-main/
├── default.project.json                    # Rojo compilation mappings
├── README.md                               # Project documentation
├── node_modules/                           # Dependency packages
└── src/
    ├── Lighting/                           # Global environment overrides
    │   └── init.meta.json                  # Lighting state configurations
    ├── ReplicatedFirst/
    │   └── BootLoader.client.lua           # Initial asset preload sequence
    ├── ReplicatedStorage/
    │   ├── App/
    │   │   ├── Config/                     # Global configurations
    │   │   │   ├── AimTrainerConfig.lua    # Target lifecycle presets
    │   │   │   ├── QBConfig.lua            # Authoritative anti-cheat metrics
    │   │   │   └── WeaponConfig.lua        # Physical gun characteristics
    │   │   ├── Enums/
    │   │   │   └── Reason.lua              # Security violation identifiers
    │   │   ├── Networking/
    │   │   │   ├── AntiCheatRemotes.lua    # Encrypted connection namespaces
    │   │   │   └── QBPackets.lua           # Serialization & TOTP algorithms
    │   │   └── Utilities/                  # Functional toolkits
    │   │       ├── HookSentinel.lua        # Client stack verification
    │   │       ├── Janitor.lua             # Memory leak clean-up interface
    │   │       ├── MathUtils.lua           # Vector and Bayesian algorithms
    │   │       ├── MetatableProtector.lua  # Structural environment locks
    │   │       ├── OBB.lua                 # 3D Oriented Bounding Box intersections
    │   │       ├── ProceduralModeler.lua   # Native CSG gun geometry builders
    │   │       ├── RateLimiter.lua         # Token-bucket network limiters
    │   │       └── Trail.lua               # Rolling ring buffer trackers
    │   ├── NovaAC/
    │   │   └── ThirdParty/
    │   │       └── Hindsight/              # Rollback & kinematic predictors
    │   ├── Shared/                         # Shared core configuration modules
    │   └── VANITY-ANTICHEAT/               # Client-replicated Vanity-AC modules
    ├── ServerScriptService/
    │   ├── NevermoreServerMain.server.lua  # Core server bootstrap layer
    │   ├── Server/                         # Merged Server-Authoritative Workspace
    │   │   ├── Modules/
    │   │   │   └── ServiceRunner.lua       # Execution sequencer for core systems
    │   │   ├── ServerBoot.server.lua       # Service instantiation bootstrap
    │   │   ├── Services/
    │   │   │   ├── AimTrainerService.lua   # Server credits reward handler
    │   │   │   ├── MapService.lua          # Procedural map assembler
    │   │   │   ├── QBCoreService.lua       # Authoritative physical tick tracker
    │   │   │   └── WeaponService.lua       # TOTP validated hit validator
    │   │   └── SubServices/                # Security modules
    │   │       ├── AdminPanelSecure.lua    # Forensic ban generators
    │   │       ├── CombatChecks.lua        # Rollback and OBB hit validator
    │   │       ├── MoveSampler.lua         # Physics state serializing interface
    │   │       ├── MovementChecks.lua      # Core speed, air, and hover checks
    │   │       ├── PhysicsChecks.lua       # Slope, velocity and noclip raycasters
    │   │       └── PlayerSession.lua       # Active player configuration structures
    │   ├── NovaAC/                         # Server-side NovaAC modules
    │   └── VanityACServer/                 # Server-side Vanity configurations
    ├── ServerStorage/
    │   └── JekyModules/                    # Datastore keys and profiles
    ├── StarterPlayer/
    │   └── StarterPlayerScripts/
    │       ├── App/
    │       │   ├── Controllers/            # Client execution modules
    │       │   │   ├── AimTrainerController.lua
    │       │   │   ├── CameraController.lua
    │       │   │   ├── DeviosUIController.lua
    │       │   │   ├── GameUIController.lua
    │       │   │   ├── PulsarPwnzorController.lua
    │       │   │   ├── SamplerController.lua
    │       │   │   ├── SecurityController.lua
    │       │   │   └── WeaponController.lua
    │       │   └── Modules/
    │       │       └── ControllerRunner.lua
    │       └── ClientBoot.client.lua       # Client-side bootstrap loader
    └── Teams/                              # Red / Blue structural presets
```

---

## 2. Core Functional Domains

### A. Procedural Level & Weapon Generation

Operation-Bravo constructs its world and weapon assets entirely inside code, avoiding reliance on external mesh assets:

#### **Dynamic Map Generation (`MapService.lua`):**
Upon server startup, `MapService` constructs a complete 1024x1024 gameplay arena out of primitive blocks:
*   **Tactical Geometry:** Spawns physical structures including a center tarmac road (`CenterStreet`), back fences, spawn regions (`RepublicSpawn`, `RaiderSpawn`), and an isolated Concrete Aim Trainer Arena.
*   **Procedural Houses:** Spawns multi-level houses featuring concrete foundation plates, ground-floor wall assemblies, functional doorway layouts, physical stair steps, and second-floor window openings for strategic sights.
*   **Obstacles:** Creates complex cover layouts like a yellow bus body complete with tyres and structural gray transport cargo trucks.

#### **Dynamic Weapon Modeling (`ProceduralModeler.lua`):**
Using custom Constructive Solid Geometry (CSG) math, the server or client generates highly detailed, physical gun models dynamically:
*   **Model Options:** Generates weapons like the R4C (compact carbine with holosights), L85A2 (bullpup build with rear-mounted magazines), MP5 (retractable stock SMG), H417 (heavy DMR with sniper scopes), OTs-03 (wooden handguard thermal sniper), M590A1 (pump-action shotgun), and the DLQ33.
*   **Saqire367 "Dragon":** Constructs a golden-themed sniper weapon with five individual crimson scale plates rotated along the scope axis (`CFrame.Angles(0, math.rad(i * 45), 0)`) wrapping a glowing gold neon scope assembly.

---

### B. Dynamic Combat Validation & Hit Detection

Combat loops do not trust client data. All hit registration actions must satisfy three layers of security before damage is recorded:

```
[Client Shot fired] ──> [Dynamic Seed (TOTP)] ──> [OBB Intersection] ──> [Bayesian Accuracy Curves] ──> [Damage Applied]
```

1.  **Dynamic TOTP Signatures (`WeaponService.lua`):**
    When a player fires, the client packages the hit event with a cryptographic security hash. The server computes a TOTP verification signature using:
    $$\text{Hash} = ((\text{Seed} \times \text{UserId}) \pmod{999983}) + \text{ActionValue}$$
    where the `ActionValue` represents the truncated coordinate vector of the hit position added to the packet sequence index.
    The server checks this signature across a narrow time-sync drift window ($\pm 1$ second) to accommodate standard latency variance while rejecting packet-replay attacks and modified hit parameters.

2.  **Historical Lag Compensation (`CombatChecks.lua`):**
    The server continuously logs the physical location history of all player characters in a rolling tracking buffer (`targetHistory`). 
    When an incoming damage remote is received, the server checks the network ping of the shooter, rolls back the target’s position to that precise timestamp, and linearly interpolates (lerps) the target's position between tracked frames to rebuild a historical snapshot.

3.  **Oriented Bounding Box (OBB) Slab Testing (`OBB.lua`):**
    Using the calculated rollback target state, the server runs a 3D Oriented Bounding Box slab intersection test:
    *   Transforms the incoming weapon ray into the target's object space using its local CFrame coordinate matrix.
    *   Tests for ray intersection across all three dimensional axes (Right, Up, Look Vectors).
    *   Rejects the shot if the intersection calculation fails or falls outside acceptable size limits (which mitigates "Silent Aim" and hitbox modification cheats).

4.  **Bayesian Statistical Analysis (`MathUtils.lua`):**
    To combat subtle aimbots, the server analyzes long-term player statistics over a rolling window of 20 shots:
    $$\text{Acc} = \frac{\text{Hits} + (w \times \mu_a)}{\text{Pellets} + w} \quad , \quad \text{HSR} = \frac{\text{Heads} + (w \times \mu_a \times \mu_h)}{\text{Hits} + w}$$
    If the computed Bayesian accuracy curve or headshot ratio deviates significantly from standard player metrics ($\text{Accuracy} > 82\%$, $\text{Headshot Ratio} > 75\%$), a silent threat flag is triggered.

---

### C. Multi-Layered Telemetry Anti-Cheat Engine

The security platform acts as a combined active defense and passive diagnostic telemetry matrix.

```
┌────────────────────────────────────────────────────────────────────────┐
│                              QB-CORE SUITE                             │
├───────────────────┬───────────────────┬────────────────────────────────┤
│  DEVIOS SENTINEL  │      NOVA AC      │         PULSAR PWNZOR          │
├───────────────────┼───────────────────┼────────────────────────────────┤
│ • Speed / Fly     │ • Voxel grids     │ • Screen FOV check             │
│ • Accel Spikes    │ • Voxel tracking  │ • Aspect-ratio locks           │
│ • Noclip Rays     │ • OBB calculations│ • AFK timer                    │
│ • Multi-tool check│ • Rollback buffers│ • Pointer-action monitors      │
└───────────────────┴───────────────────┴────────────────────────────────┘
```

#### **1. Devios Sentinel Suite (`MovementChecks.lua` & `PhysicsChecks.lua`):**
*   **Rolling Velocity Windows:** Tracks client displacements inside a sliding ring buffer (`Trail.lua`) of size `bufSize = 64`. If a player's average horizontal velocity exceeds their configured speed allowance (augmented by `speedMult` and a safety limit `speedMargin`), the violation score increases.
*   **Static Hover & Flight Detection:** Monitors duration in the air (`airTime`). If a player remains airborne for more than 2.0 seconds while maintaining vertical velocity near zero, or slowly falling in a manner inconsistent with gravity calculations, a "static hover" violation is recorded.
*   **Noclip Solid Boundary Testing:** Casts directional collision rays between consecutive player update positions. If a ray intersects a solid part with a collision normal indicating a wall layout ($\text{Normal.Y} \le \text{wallNormalY}$), the script registers a solid boundary penetration breach.
*   **Slope Validation:** Employs raycasts downward to confirm that grounded characters have valid underlying collision support, verifying that the terrain slope angle does not exceed `maxSlope = 65°`.
*   **Inventory & State Checks:** Rejects unauthorized dead-state transitions (preventing respawn exploits) and runs tool scans. If a player equips more than one weapon simultaneously to bypass holster delays, a flag is registered.

#### **2. Client-Side Sandbox Verification (`SecurityController.lua`):**
*   **Performance Benchmarking:** Continuously runs short memory-allocation loops (`verifyIndexPerformance`). Because metamethod index overrides under debugging tools alter memory garbage collection rates, anomalies in heap behavior trigger a warning.
*   **Pcall Stack Verification:** Evaluates the execution stack frame of the global `pcall` function. If standard function calls are routed through debug detours, a metatable violation kick is triggered.
*   **Self-Healing Telemetry Channel (`SelfHealSentinel.lua`):** If a system hook detour is detected on core game functions, the client automatically re-routes its secure network channels and informs the server of a sandbox threat.

#### **3. Pulsar-Pwnzor System (`PulsarPwnzorController.lua`):**
*   **Aspect Ratio Lock:** Continuously checks camera viewport ratios. Screen limits are locked between $1.0$ and $2.4$. Any anomalies maintained for longer than `KICK_TIMER = 30` seconds result in a kick (preventing wide-screen ultra-stretch field-of-view cheats).
*   **Active FOV Boundaries:** Monitors the camera's local field-of-view angle. If the FOV falls outside of the strict bounds ($30^{\circ} \le \text{FOV} \le 120^{\circ}$), the client is disconnected.

---

### D. Gameplay Mechanics & Spring Engine

#### **1. Physical Spring Solvers (`WeaponController.lua`):**
Weapon views, physical alignment offset models, visual recoil, and scope aiming use physical spring systems to keep movement feeling organic:
```
  [Mouse Motion] ───────> [Sway Spring] ──────┐
                                              ├──> [CFrame Matrix Translation]
  [Weapon Discharged] ──> [Recoil Spring] ────┤
                                              │
  [Aim Down Sights] ────> [ADS Spring] ───────┘
```
The spring-solver updates position ($x$) and velocity ($v$) values using target offsets ($t$), stiffness ($f$), and damping ($d$) coefficients:
$$\text{accel} = \frac{(t - x) \times f - v \times d}{m}$$
$$v = v + \text{accel} \times dt \times \text{speed}$$
$$x = x + v \times dt \times \text{speed}$$
*   **Sway Dynamics:** Mouse movement pushes the sway spring off-center before it pulls back to the center of the camera.
*   **ADS Camera Zoom:** Aiming shifts the viewmodel offset along a spring trajectory and blends the camera's Field of View smoothly between $90^{\circ}$ and $45^{\circ}$.
*   **Procedural Recoil:** When firing, the script applies an instant force kick to the recoil spring, shifting the viewmodel back and upward on random vectors before damping returns it to its original resting state.

#### **2. Camera Leaning System (`CameraController.lua`):**
Pressing `Q` or `E` updates target offsets to rotate and translate the player's view:
*   Smoothly offsets the camera laterally ($x$-axis) and rotates it along the roll axis ($z$-axis) using independent spring interpolation values.
*   Applies a localized camera transformation matrix:
    $$\text{CFrame}_{\text{target}} = \text{CFrame}_{\text{camera}} \times \text{CFrame.new}(\text{leanOffset}, 0, 0) \times \text{CFrame.Angles}(0, 0, \text{math.rad}(\text{leanRoll}))$$

---

### E. Concrete Aim Trainer Sandbox

The system includes a dedicated aim-training space with five training routines:

| Mode | Visual Presets | Targets | Spawn Delay | Target Lifetime | Outer Radius | Movement |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| **Gridshot** | `GridshotArena` | 3 | 0.5s | 3.0s | 15 studs | Static |
| **Microshot** | `MicroshotArena` | 2 | 0.4s | 2.0s | 6 studs | Static |
| **Tracking** | `TrackingArena` | 1 | 5.0s | 10.0s | 12 studs | Dynamic |
| **Reflex** | `ReflexArena` | 1 | 1.0s | 0.75s | 20 studs | Static |
| **Wallburst** | `WallburstArena` | 5 | 0.8s | 4.0s | 25 studs | Static |

*   **Hit Validation:** Weapon hits on practice targets are intercepted locally by `RegisterRaycastHit` inside the `AimTrainerController`. It destroys the targeted instance and fires the verification remote `TrainHit`, which updates player credits.

---

## 3. Communication Protocols & Payloads

### A. Client Telemetry Serialization (`QBPackets.lua`)
To reduce network footprint and avoid packet inspection exploits, telemetry update data is serialized into a lightweight array format before sending:

```
[ Sequence ID, ClientTimestamp, TruncatedPositionVector, TruncatedVelocityVector, StateID, FloorMaterialID ]
```

*   **Coordinate Precision Compression:**
    Numerical coordinates are scaled and rounded to reduce packet size:
    ```lua
    local function snapNum(val: number, scale: number)
        return math.round(val * scale) / scale
    end
    ```
    *   **Vector Coordinates:** Rounded to the nearest $1/100\text{th}$ of a stud (scale: `100`).
    *   **Velocity Coordinates:** Rounded to the nearest $1/10\text{th}$ of a stud (scale: `10`).
    *   **State & Materials:** Transmitted as flat integer indices corresponding to Enums rather than full string names.

### B. Remote Security Specifications (`QBConfig.lua`)
The Remote Security setup is configured to enforce strict call verification limits across all network channels:

```lua
RemoteEventSecurity = {
    StrictWhitelistEnabled = true,
    WhitelistedRemoteEvents = { 'UpdateInventory', 'PurchaseItem', 'DealDamage', 'FireWeapon', 'TrainHit', 'RequestUI' },
    ArgumentValidationEnabled = true,
    RateLimitingEnabled = true,
    MaxRemoteEventsPerSecond = 8,
    RateLimitTimeFrame = 1,
    EnableDistanceCheck = true,
    MaxRemoteDistance = 300,
}
```

*   Any remote call originating from a coordinate farther than $300$ studs from the target position, or exceeding $8$ executions per second, is dropped by the server's rate-limiting handler.

---

## 4. Administrative Controls & Forensic Tooling

```
            ┌──────────────────────────────────────────┐
            │       DEVIOS CONTROL DECK v5.0           │
            ├──────────────────────────────────────────┤
            │ [Active Bans]  [Kick Target] [Bring/Goto]│
            └──────────────────────────────────────────┘
```

The secure control panel (`DeviosUIController.lua` & `AdminPanelSecure.lua`) allows administrators to monitor server status and enforce security updates:
*   **Authorization Check:** Upon request, `adminVerify` checks the administrator’s permissions against User ID arrays or group rankings (`GetRankInGroup`). If authorized, the server generates and shares a unique session token seed.
*   **Secure Remotes:** Command requests must include an authorization hash. This is generated on the client by calling:
    $$\text{ExpectedToken} = \text{Packets.generateHash}(\text{SessionSeed}, \text{UserId}, \text{ActionValue})$$
    where the Action Value corresponds to a predefined command index (e.g., Kick: `10`, Ban: `20`, Bring: `30`, Goto: `40`). Calls containing incorrect hashes are dropped, and the sender is flagged.
*   **Persistent Ban System:** Persistent bans are written directly to DataStore platforms (`DEVIOS_PersistentBans_v5`).
*   **Forensic Threat Reporting:** When a persistent ban or kick is triggered, the system generates a detailed diagnostic report identifying the specific security exception:

```
CRITICAL SECURITY EXCEPTION
---------------------------
Threat Vector : [Hitbox Slab-Test Vector Alignment Failure]
Diagnostic    : Slab-Test distance threshold delta exceeding limit
Heuristic     : Aimbot/SilentAim heuristic profile flag activated
Crypt Token   : 0x8DF9C01A
Forensic Trace: Client sandbox metatable violation.
```
