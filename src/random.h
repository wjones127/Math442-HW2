#pragma once
/**
 * @brief Gives random float in range
 *
 * Note: this implementation does not have a real uniform distribution.
 *
 * @param lower_bound Smallest number possible
 * @param upper_bound Largest number possible
 * @return a float
 */
float random_float (int32_t lower_bound, int32_t upper_bound);

/**
 * @brief Gives a random positive 32-bit integer.
 *
 * Note: this implementation does not have a real uniform distribution.
 *
 * @param lower_bound Smallest integer possible
 * @param upper_bound Largest integer possible
 * @return a 32-bit unsigned integer
 */
uint32_t random_int (int32_t lower_bound, int32_t upper_bound) ;

/**
 * @brief Gives a random byte
 *
 * @return A random 8-bit integer.
 */
uint8_t random_byte ();

/**
 * @brief Generates an array of non-negative integers less than bound.
 *
 * @param array_size Number of integers in array
 * @param bound Maximum size of integers
 * @return A pointer to the allocated array
 */
uint32_t * generate_random_ints (size_t array_size, uint32_t bound);

/**
 * @brief Gives an array of random bytes
 *
 * @param array_size Number of bytes to generate
 * @return A pointer to the allocated array of bytes
 */
uint8_t * generate_random_bytes (size_t array_size);
