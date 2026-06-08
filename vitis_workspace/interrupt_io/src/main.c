#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include <xio.h>
#include <mb_interface.h>
#include "xparameters.h"
#include "platform.h"

// -Wl,--start-group,-lxil,-lgcc,-lc,--end-group

#define C_USE_UART 1

#define C_BASE_VECTORS XPAR_MICROBLAZE_0_BASE_VECTORS

#define MICROBLAZE_INTERRUPT (C_BASE_VECTORS + 0x10)

// NOTE: Define the UART_BASE_ADDRESS.
#define UART_BASE_ADDRESS XPAR_MDM_1_BASEADDR

// NOTE: Define the UART register offset. Hint: Look for the register map in the product guide
#define UART_RX_FIFO        0x00
#define UART_TX_FIFO        0x04
#define UART_STATUS         0x08
#define UART_CTRL           0x0C

// NOTE: Define the bit masks for the appropriate status flags. Hint: Look for the status registers in the product guide
#define RX_FIFO_VALID_DATA  1 << 0
#define RX_FIFO_FULL        1 << 1
#define TX_FIFO_EMPTY       1 << 2
#define TX_FIFO_FULL        1 << 3

// NOTE: Define interrupt enable bit for the UART module
#define UART_INTERRUPT_ENABLED 1 << 4

// More information in MicroBlaze product guide!
void ISR() __attribute__((interrupt_handler));
u32 count=0;

bool get_flag(u32 mask) {
    u32 status = XIo_In32(UART_BASE_ADDRESS + UART_STATUS);
    return ((status & mask) != 0) ? true : false;
}

void ISR(void)
{
	// TODO: Service the interrupt.
    printf("ISR called!");
	count++;
}

int main(void) {
    init_platform();
    printf("starting...\n");

	// NOTE: Enable the UART to generate interrupts
    int uart_ctrl = XIo_In8(UART_BASE_ADDRESS + UART_CTRL + 3);
    uart_ctrl |= UART_INTERRUPT_ENABLED;
    XIo_Out8(UART_BASE_ADDRESS + UART_TX_FIFO + 3, uart_ctrl);

    // NOTE: Enable microblaze to respond to interrupts
    microblaze_enable_interrupts();

    // NOTE: register the interrupt
    microblaze_register_handler((XInterruptHandler) ISR, NULL);

	while(1) {
        ;
	}

	// TODO: Disable Interrupts
    microblaze_disable_interrupts();

    cleanup_platform();
	// Exit normally
	return 0;
}

