
// Copyright 2023 ZSA Technology Labs, Inc <@zsa>
// Copyright 2023 Christopher Courtney, aka Drashna Jael're  (@drashna) <drashna@live.com>
// SPDX-License-Identifier: GPL-2.0-or-later

#include QMK_KEYBOARD_H

enum layers {
    _BASE,
    _FN,
    _MEDIA,
    _GAMING,
    _TMUX,
};

enum custom_keycodes {
    TMUX_H = SAFE_RANGE,
    TMUX_J,
    TMUX_K,
    TMUX_L,
    TMUX_COPY,
    TMUX_NEW,
    TMUX_CLOSE,
    TMUX_ZOOM,
    TMUX_VSPLIT,
    TMUX_HSPLIT,
    TMUX_PREV,
    TMUX_FIND_SESSION,
    TMUX_FIND_WINDOW,
    TMUX_Y,
    TMUX_WIN_0,
    TMUX_WIN_1,
    TMUX_WIN_2,
    TMUX_WIN_3,
    TMUX_WIN_4,
    TMUX_WIN_5,
    TMUX_WIN_6,
    TMUX_WIN_7,
    TMUX_WIN_8,
    TMUX_WIN_9,
    TMUX_NAV_WIN,  // Handles both navigation and moving windows based on shift
};

#ifdef RGB_MATRIX_ENABLE
// Animation types
// RGB_MATRIX_BREATHING
// RGB_MATRIX_SOLID_REACTIVE_SIMPLE
// RGB_MATRIX_GRADIENT_UP_DOWN
// RGB_MATRIX_RAINBOW_PINWHEELS
// RGB_MATRIX_RAINBOW_MOVING_CHEVRON
layer_state_t layer_state_set_user(layer_state_t state) {
    if (layer_state_cmp(state, _GAMING)) {
        rgb_matrix_mode(RGB_MATRIX_SOLID_COLOR);
        rgb_matrix_sethsv(HSV_BLUE); // or your chosen color
    } else {
        rgb_matrix_mode(RGB_MATRIX_RAINBOW_PINWHEELS);  // your preferred pattern
    }
    return state;
}
#endif

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = LAYOUT(
        KC_GRAVE, KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    TG(_GAMING),
        KC_EQUAL, KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSLS,
        KC_LSFT, KC_A, KC_S, KC_D, MT(MOD_LCTL, KC_F), KC_G,                        KC_H, MT(MOD_RCTL, KC_J), KC_K, KC_L, KC_SCLN, RSFT_T(KC_QUOT),
        KC_LGUI, MT(MOD_LALT, KC_Z), KC_X, KC_C, KC_V, KC_B,                        KC_N, KC_M, KC_COMMA, KC_DOT, KC_SLSH, KC_ESC,
                                    LT(_TMUX, KC_ENT), LT(_FN, KC_TAB),              KC_BSPC, LT(_MEDIA, KC_SPC)
    ),

    [_FN] = LAYOUT(
        KC_ESC,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                        KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,
        KC_GRV,  KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,                      KC_7,    KC_8,    KC_9,    KC_MINS, KC_SLSH, KC_F12,
        _______, KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN,                      KC_4,    KC_5,    KC_6,    KC_PLUS, KC_ASTR, KC_BSPC,
        _______, _______, KC_LBRC, KC_RBRC, KC_LCBR, KC_RCBR,                      KC_1,    KC_2,    KC_3,    KC_DOT,  KC_EQL,  KC_ENT,
                                             _______, _______,    _______, KC_0
    ),

    [_MEDIA] = LAYOUT(
        RM_TOGG, QK_KB,   RM_NEXT, RGB_M_P, RM_VALD, RM_VALU,                      _______, _______, _______, _______, _______, QK_BOOT,
        _______, _______, KC_VOLD, KC_VOLU, KC_MUTE, _______,                      _______, _______, _______, _______, _______, _______,
        _______, KC_MPRV, KC_MNXT, KC_MSTP, KC_MPLY, _______,                      KC_LEFT, KC_DOWN, KC_UP  , KC_RIGHT, _______, _______,
        _______, _______, _______, _______, _______, _______,                      KC_HOME, KC_PGDN, KC_PGUP, KC_END, _______, _______,
                                             _______, _______,    _______, _______
    ),

    [_GAMING] = LAYOUT(
        KC_GRAVE,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    TG(_GAMING),
        KC_LCTL,   KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSLS,
        KC_LSFT,   KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_SPC,
        _______,   KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_ESC,
                                             KC_SPC, _______,    _______, _______
    ),

    [_TMUX] = LAYOUT(
        _______, TMUX_WIN_1, TMUX_WIN_2, TMUX_WIN_3, TMUX_WIN_4, TMUX_WIN_5,           TMUX_WIN_6, TMUX_WIN_7, TMUX_WIN_8, TMUX_WIN_9, TMUX_WIN_0, _______,
        _______, _______,    _______,    _______,    _______,    _______,              TMUX_Y,     _______,    _______,    TMUX_VSPLIT,TMUX_COPY,  TMUX_HSPLIT,
        _______, TMUX_PREV,  TMUX_FIND_SESSION, _______, TMUX_FIND_WINDOW, _______,      TMUX_H,     TMUX_J,     TMUX_K,     TMUX_L,     _______,    _______,
        _______, TMUX_ZOOM,  TMUX_CLOSE, TMUX_NEW,   TMUX_VSPLIT,TMUX_HSPLIT,          TMUX_COPY,  _______,    KC_COMMA,   KC_DOT,     _______,    _______,
                                                      _______,    _______,              _______,    _______
    ),
};

// Helper function to send tmux prefix (Ctrl+B)
static void send_tmux_prefix(void) {
    register_code(KC_LCTL);
    tap_code(KC_B);
    unregister_code(KC_LCTL);
    wait_ms(50);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    // Handle comma/period in TMUX layer for window navigation
    if (IS_LAYER_ON(_TMUX) && record->event.pressed) {
        const uint8_t mods = get_mods();
        const bool shifted = (mods & MOD_MASK_SHIFT);

        if (keycode == KC_COMMA) {
            if (shifted) {
                // Shift+, = < = Move window left
                del_mods(MOD_MASK_SHIFT);
                register_code(KC_LCTL);
                register_code(KC_LSFT);
                tap_code(KC_LEFT);
                unregister_code(KC_LSFT);
                unregister_code(KC_LCTL);
                set_mods(mods);
            } else {
                // , = Previous window (Ctrl+B, p)
                send_tmux_prefix();
                tap_code(KC_P);
            }
            return false;
        } else if (keycode == KC_DOT) {
            if (shifted) {
                // Shift+. = > = Move window right
                del_mods(MOD_MASK_SHIFT);
                register_code(KC_LCTL);
                register_code(KC_LSFT);
                tap_code(KC_RIGHT);
                unregister_code(KC_LSFT);
                unregister_code(KC_LCTL);
                set_mods(mods);
            } else {
                // . = Next window (Ctrl+B, n)
                send_tmux_prefix();
                tap_code(KC_N);
            }
            return false;
        }
    }

    if (record->event.pressed) {
        switch (keycode) {
            // Split navigation
            case TMUX_H:
                send_tmux_prefix();
                tap_code(KC_H);
                return false;
            case TMUX_J:
                send_tmux_prefix();
                tap_code(KC_J);
                return false;
            case TMUX_K:
                send_tmux_prefix();
                tap_code(KC_K);
                return false;
            case TMUX_L:
                send_tmux_prefix();
                tap_code(KC_L);
                return false;

            // Copy mode (Ctrl+B, [)
            case TMUX_COPY:
                send_tmux_prefix();
                tap_code(KC_LBRC);
                return false;

            // New window (Ctrl+B, c)
            case TMUX_NEW:
                send_tmux_prefix();
                tap_code(KC_C);
                return false;

            // Close pane (Ctrl+B, x)
            case TMUX_CLOSE:
                send_tmux_prefix();
                tap_code(KC_X);
                return false;

            // Zoom toggle (Ctrl+B, z)
            case TMUX_ZOOM:
                send_tmux_prefix();
                tap_code(KC_Z);
                return false;

            // Vertical split (Ctrl+B, %)
            case TMUX_VSPLIT:
                send_tmux_prefix();
                register_code(KC_LSFT);
                tap_code(KC_5);
                unregister_code(KC_LSFT);
                return false;

            // Horizontal split (Ctrl+B, ")
            case TMUX_HSPLIT:
                send_tmux_prefix();
                register_code(KC_LSFT);
                tap_code(KC_QUOT);
                unregister_code(KC_LSFT);
                return false;

            // Previous window (Ctrl+B, p)
            case TMUX_PREV:
                send_tmux_prefix();
                tap_code(KC_P);
                return false;

            // Find session (Ctrl+B, s)
            case TMUX_FIND_SESSION:
                send_tmux_prefix();
                tap_code(KC_S);
                return false;

            // Find window (Ctrl+B, f)
            case TMUX_FIND_WINDOW:
                send_tmux_prefix();
                tap_code(KC_F);
                return false;

            // Kill pane/window (Ctrl+B, y)
            case TMUX_Y:
                send_tmux_prefix();
                tap_code(KC_Y);
                return false;

            // Window switching (Ctrl+B, 0-9)
            case TMUX_WIN_0:
                send_tmux_prefix();
                tap_code(KC_0);
                return false;
            case TMUX_WIN_1:
                send_tmux_prefix();
                tap_code(KC_1);
                return false;
            case TMUX_WIN_2:
                send_tmux_prefix();
                tap_code(KC_2);
                return false;
            case TMUX_WIN_3:
                send_tmux_prefix();
                tap_code(KC_3);
                return false;
            case TMUX_WIN_4:
                send_tmux_prefix();
                tap_code(KC_4);
                return false;
            case TMUX_WIN_5:
                send_tmux_prefix();
                tap_code(KC_5);
                return false;
            case TMUX_WIN_6:
                send_tmux_prefix();
                tap_code(KC_6);
                return false;
            case TMUX_WIN_7:
                send_tmux_prefix();
                tap_code(KC_7);
                return false;
            case TMUX_WIN_8:
                send_tmux_prefix();
                tap_code(KC_8);
                return false;
            case TMUX_WIN_9:
                send_tmux_prefix();
                tap_code(KC_9);
                return false;
        }
    }
    return true;
}

