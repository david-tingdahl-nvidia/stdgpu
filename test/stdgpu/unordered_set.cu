/*
 *  Copyright 2019 Patrick Stotko
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <stdgpu/unordered_set.cuh>

#include <cstddef>

#include <stdgpu/platform.h>


namespace
{
    struct vec3int16
    {
        vec3int16() = default;

        STDGPU_HOST_DEVICE
        vec3int16(const std::int16_t x,
                  const std::int16_t y,
                  const std::int16_t z)
            : x(x),
              y(y),
              z(z)
        {

        }

        std::int16_t x = 0;
        std::int16_t y = 0;
        std::int16_t z = 0;
    };


    STDGPU_HOST_DEVICE bool
    operator==(const vec3int16& lhs,
               const vec3int16& rhs)
    {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.z == rhs.z;
    }


    struct less
    {
        inline STDGPU_HOST_DEVICE bool
        operator()(const vec3int16& lhs,
                   const vec3int16& rhs) const
        {
            if (lhs.x < rhs.x) return true;
            if (lhs.x > rhs.x) return false;

            if (lhs.y < rhs.y) return true;
            if (lhs.y > rhs.y) return false;

            if (lhs.z < rhs.z) return true;
            if (lhs.z > rhs.z) return false;

            return true;
        }
    };


    struct hash
    {
        inline STDGPU_HOST_DEVICE std::size_t
        operator()(const vec3int16& key) const
        {
            return (static_cast<std::size_t>(key.x) * static_cast<std::size_t>(73856093u))
                 ^ (static_cast<std::size_t>(key.y) * static_cast<std::size_t>(19349669u))
                 ^ (static_cast<std::size_t>(key.z) * static_cast<std::size_t>(83492791u));
        }
    };


    inline STDGPU_HOST_DEVICE vec3int16
    key_to_value(const vec3int16& key)
    {
        return key;
    }


    inline STDGPU_HOST_DEVICE vec3int16
    value_to_key(const vec3int16& key)
    {
        return key;
    }
}


#define STDGPU_UNORDERED_DATASTRUCTURE_TEST_CLASS stdgpu_unordered_set
#define STDGPU_UNORDERED_DATASTRUCTURE_TYPE stdgpu::unordered_set<vec3int16, hash>
#define STDGPU_UNORDERED_DATASTRUCTURE_KEY2VALUE key_to_value
#define STDGPU_UNORDERED_DATASTRUCTURE_VALUE2KEY value_to_key


#include "unordered_datastructure.inc"
